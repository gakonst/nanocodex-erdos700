use std::{
    fs::{self, File},
    io::{Read, Seek, SeekFrom},
    path::{Component, Path, PathBuf},
};

use eyre::{Result, WrapErr};
use nanocodex::{
    Tool, ToolContext, ToolDefinition, ToolExecution, ToolInput, ToolResult, async_trait,
};
use serde::{Deserialize, Serialize};
use serde_json::json;
use sha2::{Digest, Sha256};

const MAX_READ_BYTES: usize = 64 * 1024;
const MAX_LIST_ENTRIES: usize = 1_000;
const RECORDER_OWNED_FILE: &str = "events.jsonl";

#[derive(Clone)]
pub(crate) struct ArtifactReader {
    runs_directory: PathBuf,
}

#[derive(Deserialize)]
#[serde(tag = "operation", rename_all = "kebab-case", deny_unknown_fields)]
enum ArtifactInput {
    List {
        path: String,
        #[serde(default)]
        recursive: bool,
        max_entries: usize,
    },
    Read {
        path: String,
        #[serde(default)]
        offset: u64,
        max_bytes: usize,
    },
}

#[derive(Serialize)]
#[serde(tag = "operation", rename_all = "kebab-case")]
enum ArtifactOutput {
    List {
        path: String,
        entries: Vec<ArtifactEntry>,
        truncated: bool,
    },
    Read {
        path: String,
        offset: u64,
        bytes_read: usize,
        total_bytes: u64,
        next_offset: Option<u64>,
        chunk_sha256: String,
        content: String,
    },
}

#[derive(Serialize)]
struct ArtifactEntry {
    path: String,
    kind: &'static str,
    bytes: Option<u64>,
}

impl ArtifactReader {
    pub(crate) fn new(workspace: &Path) -> Result<Self> {
        let runs_directory = workspace.join("runs");
        fs::create_dir_all(&runs_directory).wrap_err("failed to create runs directory")?;
        Ok(Self {
            runs_directory: runs_directory
                .canonicalize()
                .wrap_err("failed to resolve runs directory")?,
        })
    }

    fn inspect(&self, input: ArtifactInput) -> Result<ArtifactOutput> {
        match input {
            ArtifactInput::List {
                path,
                recursive,
                max_entries,
            } => self.list(path, recursive, max_entries),
            ArtifactInput::Read {
                path,
                offset,
                max_bytes,
            } => self.read(path, offset, max_bytes),
        }
    }

    fn list(&self, path: String, recursive: bool, max_entries: usize) -> Result<ArtifactOutput> {
        if !(1..=MAX_LIST_ENTRIES).contains(&max_entries) {
            return Err(std::io::Error::other(format!(
                "max_entries must be between 1 and {MAX_LIST_ENTRIES}"
            ))
            .into());
        }
        let directory = self.resolve(&path)?;
        if !directory.is_dir() {
            return Err(std::io::Error::other("artifact list path must be a directory").into());
        }
        let mut pending = vec![directory];
        let mut entries = Vec::new();
        let mut truncated = false;
        while let Some(current) = pending.pop() {
            let mut children = fs::read_dir(&current)
                .wrap_err("failed to list artifact directory")?
                .collect::<std::io::Result<Vec<_>>>()?;
            children.sort_by_key(std::fs::DirEntry::file_name);
            for child in children {
                if entries.len() == max_entries {
                    truncated = true;
                    break;
                }
                let child_path = child.path();
                if child_path
                    .file_name()
                    .is_some_and(|name| name == RECORDER_OWNED_FILE)
                {
                    continue;
                }
                let metadata = child
                    .metadata()
                    .wrap_err("failed to inspect artifact entry")?;
                let relative = self.relative(&child_path)?;
                let (kind, bytes) = if metadata.is_file() {
                    ("file", Some(metadata.len()))
                } else if metadata.is_dir() {
                    ("directory", None)
                } else {
                    ("other", None)
                };
                entries.push(ArtifactEntry {
                    path: relative,
                    kind,
                    bytes,
                });
                if recursive && metadata.is_dir() {
                    let canonical = child_path
                        .canonicalize()
                        .wrap_err("failed to resolve artifact subdirectory")?;
                    self.ensure_contained(&canonical)?;
                    pending.push(canonical);
                }
            }
            if truncated || !recursive {
                break;
            }
        }
        entries.sort_by(|left, right| left.path.cmp(&right.path));
        Ok(ArtifactOutput::List {
            path,
            entries,
            truncated,
        })
    }

    fn read(&self, path: String, offset: u64, max_bytes: usize) -> Result<ArtifactOutput> {
        if !(1..=MAX_READ_BYTES).contains(&max_bytes) {
            return Err(std::io::Error::other(format!(
                "max_bytes must be between 1 and {MAX_READ_BYTES}"
            ))
            .into());
        }
        if Path::new(&path)
            .file_name()
            .is_some_and(|name| name == RECORDER_OWNED_FILE)
        {
            return Err(std::io::Error::other(
                "live recorder-owned event traces are not research artifacts",
            )
            .into());
        }
        let file_path = self.resolve(&path)?;
        if !file_path.is_file() {
            return Err(std::io::Error::other("artifact read path must be a regular file").into());
        }
        if file_path
            .file_name()
            .is_some_and(|name| name == RECORDER_OWNED_FILE)
        {
            return Err(std::io::Error::other(
                "live recorder-owned event traces are not research artifacts",
            )
            .into());
        }
        let mut file = File::open(&file_path).wrap_err("failed to open artifact")?;
        let total_bytes = file.metadata()?.len();
        if offset > total_bytes {
            return Err(std::io::Error::other("artifact offset exceeds file size").into());
        }
        file.seek(SeekFrom::Start(offset))?;
        let mut bytes = vec![0; max_bytes];
        let bytes_read = file.read(&mut bytes)?;
        bytes.truncate(bytes_read);
        let consumed = offset + bytes_read as u64;
        Ok(ArtifactOutput::Read {
            path,
            offset,
            bytes_read,
            total_bytes,
            next_offset: (consumed < total_bytes).then_some(consumed),
            chunk_sha256: format!("{:x}", Sha256::digest(&bytes)),
            content: String::from_utf8_lossy(&bytes).into_owned(),
        })
    }

    fn resolve(&self, relative: &str) -> Result<PathBuf> {
        if relative == "." {
            return Ok(self.runs_directory.clone());
        }
        let path = Path::new(relative);
        if relative.trim().is_empty()
            || path.is_absolute()
            || path
                .components()
                .any(|component| !matches!(component, Component::Normal(_)))
        {
            return Err(std::io::Error::other(
                "artifact path must be nonempty and relative to runs/ without `..` components",
            )
            .into());
        }
        let canonical = self
            .runs_directory
            .join(path)
            .canonicalize()
            .wrap_err_with(|| {
                format!(
                    "failed to resolve artifact path `{relative}`; list `.` to discover paths beneath runs/"
                )
            })?;
        self.ensure_contained(&canonical)?;
        Ok(canonical)
    }

    fn ensure_contained(&self, path: &Path) -> Result<()> {
        if !path.starts_with(&self.runs_directory) {
            return Err(std::io::Error::other("artifact path escapes runs directory").into());
        }
        Ok(())
    }

    fn relative(&self, path: &Path) -> Result<String> {
        Ok(path
            .strip_prefix(&self.runs_directory)
            .wrap_err("artifact entry escaped runs directory")?
            .to_string_lossy()
            .into_owned())
    }
}

#[async_trait]
impl Tool for ArtifactReader {
    fn name(&self) -> &'static str {
        "inspect_research_artifacts"
    }

    fn definition(&self) -> ToolDefinition {
        ToolDefinition::function(
            self.name(),
            "List or read retained files beneath the host's runs/ directory without consuming an exact-computation job. This capability is read-only, path-contained, paginated, and size-bounded. Use run_exact_job only for computation, not for find/cat/sed.",
            json!({
                "oneOf": [
                    {
                        "type": "object",
                        "properties": {
                            "operation": { "const": "list" },
                            "path": { "type": "string", "description": "Directory relative to runs/. Use `.` to list the available run directories." },
                            "recursive": { "type": "boolean", "default": false },
                            "max_entries": { "type": "integer", "minimum": 1, "maximum": MAX_LIST_ENTRIES }
                        },
                        "required": ["operation", "path", "max_entries"],
                        "additionalProperties": false
                    },
                    {
                        "type": "object",
                        "properties": {
                            "operation": { "const": "read" },
                            "path": { "type": "string", "description": "File relative to runs/." },
                            "offset": { "type": "integer", "minimum": 0, "default": 0 },
                            "max_bytes": { "type": "integer", "minimum": 1, "maximum": MAX_READ_BYTES }
                        },
                        "required": ["operation", "path", "max_bytes"],
                        "additionalProperties": false
                    }
                ]
            }),
        )
    }

    async fn execute(&self, input: ToolInput, _context: ToolContext<'_>) -> ToolResult {
        let output = self.inspect(input.decode_json()?)?;
        Ok(ToolExecution::json(&output))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn workspace() -> Result<PathBuf> {
        let path = std::env::temp_dir().join(format!(
            "nanocodex-erdos-artifacts-{}-{}",
            std::process::id(),
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)?
                .as_nanos()
        ));
        fs::create_dir_all(path.join("runs/run-1/sub"))?;
        fs::write(path.join("runs/run-1/report.md"), "abcdefghij")?;
        fs::write(path.join("runs/run-1/sub/data.json"), "{}")?;
        fs::write(path.join("runs/run-1/events.jsonl"), "{}\n")?;
        Ok(path)
    }

    #[test]
    fn reads_paginated_chunks_and_lists_recursively() -> Result<()> {
        let workspace = workspace()?;
        let reader = ArtifactReader::new(&workspace)?;
        let ArtifactOutput::Read {
            content,
            next_offset,
            ..
        } = reader.read("run-1/report.md".to_owned(), 2, 4)?
        else {
            panic!("expected read output");
        };
        assert_eq!(content, "cdef");
        assert_eq!(next_offset, Some(6));
        let ArtifactOutput::List { entries, .. } = reader.list("run-1".to_owned(), true, 10)?
        else {
            panic!("expected list output");
        };
        assert!(entries.iter().any(|entry| entry.path == "run-1/report.md"));
        assert!(
            entries
                .iter()
                .any(|entry| entry.path == "run-1/sub/data.json")
        );
        assert!(
            entries
                .iter()
                .all(|entry| entry.path != "run-1/events.jsonl")
        );
        let ArtifactOutput::List { entries, .. } = reader.list(".".to_owned(), false, 10)? else {
            panic!("expected root list output");
        };
        assert!(
            entries
                .iter()
                .any(|entry| entry.path == "run-1" && entry.kind == "directory")
        );
        fs::remove_dir_all(workspace)?;
        Ok(())
    }

    #[test]
    fn rejects_paths_outside_runs() -> Result<()> {
        let workspace = workspace()?;
        let reader = ArtifactReader::new(&workspace)?;
        assert!(reader.read("../secret".to_owned(), 0, 10).is_err());
        assert!(reader.list("/tmp".to_owned(), false, 10).is_err());
        fs::remove_dir_all(workspace)?;
        Ok(())
    }

    #[test]
    fn rejects_recorder_owned_event_traces() -> Result<()> {
        let workspace = workspace()?;
        let reader = ArtifactReader::new(&workspace)?;

        let Err(error) = reader.read("run-1/events.jsonl".to_owned(), 0, 10) else {
            panic!("event trace reads must be rejected");
        };
        assert!(error.to_string().contains("recorder-owned event traces"));

        fs::remove_dir_all(workspace)?;
        Ok(())
    }
}
