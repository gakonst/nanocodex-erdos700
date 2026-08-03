use std::{env, fs, path::Path, process::Command};

use sha2::{Digest, Sha256};

const NANOCODEX_PATHS: &[&str] = &[
    "Cargo.toml",
    "crates/nanocodex-core",
    "crates/nanocodex-service",
    "crates/nanocodex-tools",
    "crates/nanocodex-mcp",
    "crates/nanocodex-macros",
    "crates/nanocodex",
];

struct SourceState {
    revision: String,
    dirty: bool,
    sha256: String,
}

fn main() {
    let experiment = Path::new(env!("CARGO_MANIFEST_DIR"));
    let nanocodex = experiment.join("../nanocodex-latest");
    emit_rerun_paths(&nanocodex, NANOCODEX_PATHS);
    emit_git_rerun_paths(&nanocodex);
    let state = source_state(&nanocodex, NANOCODEX_PATHS);
    println!("cargo:rustc-env=NANOCODEX_GIT_COMMIT={}", state.revision);
    println!("cargo:rustc-env=NANOCODEX_BUILD_DIRTY={}", state.dirty);
    println!("cargo:rustc-env=NANOCODEX_SOURCE_SHA256={}", state.sha256);
}

fn emit_rerun_paths(root: &Path, paths: &[&str]) {
    for path in paths {
        println!("cargo:rerun-if-changed={}", root.join(path).display());
    }
}

fn emit_git_rerun_paths(root: &Path) {
    for logical in ["HEAD", "index", "packed-refs"] {
        emit_git_path(root, logical);
    }
}

fn emit_git_path(root: &Path, logical: &str) {
    let Some(path) = git_output(root, &["rev-parse", "--git-path", logical])
        .map(|output| String::from_utf8_lossy(&output).trim().to_owned())
        .filter(|path| !path.is_empty())
    else {
        return;
    };
    let path = Path::new(&path);
    let path = if path.is_absolute() {
        path.to_owned()
    } else {
        root.join(path)
    };
    println!("cargo:rerun-if-changed={}", path.display());
}

fn source_state(root: &Path, paths: &[&str]) -> SourceState {
    let revision = git_output(root, &["rev-parse", "HEAD"])
        .map(|output| String::from_utf8_lossy(&output).trim().to_owned())
        .filter(|revision| !revision.is_empty())
        .unwrap_or_else(|| "unknown".to_owned());
    let mut status_args = vec!["status", "--porcelain", "--"];
    status_args.extend_from_slice(paths);
    let dirty = git_output(root, &status_args).is_none_or(|output| !output.is_empty());

    let mut list_args = vec!["ls-files", "-c", "-m", "-o", "--exclude-standard", "--"];
    list_args.extend_from_slice(paths);
    let listed = git_output(root, &list_args).unwrap_or_default();
    let mut files = String::from_utf8_lossy(&listed)
        .lines()
        .map(str::to_owned)
        .collect::<Vec<_>>();
    files.sort_unstable();
    files.dedup();

    let mut digest = Sha256::new();
    for relative in files {
        let path = root.join(&relative);
        let Ok(content) = fs::read(&path) else {
            continue;
        };
        digest.update(relative.as_bytes());
        digest.update([0]);
        digest.update(
            u64::try_from(content.len())
                .unwrap_or(u64::MAX)
                .to_le_bytes(),
        );
        digest.update(content);
    }
    SourceState {
        revision,
        dirty,
        sha256: format!("{:x}", digest.finalize()),
    }
}

fn git_output(root: &Path, args: &[&str]) -> Option<Vec<u8>> {
    let output = Command::new("git")
        .args(args)
        .current_dir(root)
        .output()
        .ok()?;
    output.status.success().then_some(output.stdout)
}
