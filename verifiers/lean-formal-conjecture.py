#!/usr/bin/env python3

"""Verify one of the frozen inference-first Formal Conjectures campaigns."""

from __future__ import annotations

import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path


FORMAL_CONJECTURES_COMMIT = "e751934294a381afd2d5fc1124c5953c8e25f9fa"
MAX_SOLUTION_BYTES = 2 * 1024 * 1024
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}

TARGETS = {
    "# Erdős problem 700(ii): an unconditional strict binomial-gcd family": """
answer({answer}) ↔
  {n : ℕ | ¬ n.Prime ∧ 1 < n ∧ (Erdos700.f n) ^ 2 > n}.Infinite
""",
    "# Erdős problem 156: remove the logarithm from small maximal Sidon sets": """
answer({answer}) ↔
  (fun N ↦ (Erdos156.minMaximalSidonSet N : ℝ)) =O[Filter.atTop]
    (fun N ↦ (N : ℝ) ^ (1 / 3 : ℝ))
""",
    "# Erdős problem 579: dense octahedron-free graphs": """
answer({answer}) ↔
  ∀ δ : ℝ, 0 < δ → ∃ c : ℝ, 0 < c ∧ ∀ᶠ n : ℕ in Filter.atTop,
    ∀ G : SimpleGraph (Fin n), Erdos579.octahedron.Free G →
      δ * (n : ℝ) ^ 2 ≤ G.edgeFinset.card →
        c * n ≤ (G.indepNum : ℝ)
""",
    "# Erdős Problem 700(iii): arbitrary logarithmic saving": """
answer({answer}) ↔
  (∀ A : ℝ, 0 < A → ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ,
    ¬ n.Prime → 1 < n →
      (Erdos700.f n : ℝ) ≤ C * (n : ℝ) / (Real.log n) ^ A)
""",
}

FORBIDDEN_SOURCE = re.compile(
    r"\b(sorry|admit|axiom|constant|opaque|unsafe|macro|syntax|elab)\b"
    r"|^\s*#"
    r"|set_option\s+google\.answer",
    re.MULTILINE,
)


def fail(message: str) -> int:
    print(json.dumps({"accepted": False, "error": message}), file=sys.stderr)
    return 1


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def artifacts_from_manifest(manifest_path: Path) -> tuple[Path, dict[str, Path]]:
    manifest = load_json(manifest_path)
    run_directory = manifest_path.parent.parent.resolve()
    artifacts: dict[str, Path] = {}
    for artifact in manifest.get("artifacts", []):
        relative = artifact.get("path")
        expected = artifact.get("sha256")
        if not isinstance(relative, str) or not isinstance(expected, str):
            raise ValueError("malformed frozen artifact entry")
        path = (run_directory / relative).resolve()
        if run_directory not in path.parents or not path.is_file():
            raise ValueError(f"artifact escapes or is missing: {relative}")
        if sha256(path) != expected:
            raise ValueError(f"artifact hash changed after freeze: {relative}")
        if path.name in artifacts:
            raise ValueError(f"duplicate frozen artifact basename: {path.name}")
        artifacts[path.name] = path
    required = {"candidate.json", "solution.lean", "research-note.md", "source-audit.md"}
    missing = sorted(required - artifacts.keys())
    if missing:
        raise ValueError(f"frozen candidate is missing required artifacts: {missing}")
    return run_directory, artifacts


def select_target(problem: str) -> str:
    matches = [template for marker, template in TARGETS.items() if marker in problem]
    if len(matches) != 1:
        raise ValueError("problem.md does not identify exactly one pre-approved Lean target")
    return matches[0]


def formal_conjectures_root() -> Path:
    candidates = [
        os.environ.get("FORMAL_CONJECTURES_ROOT"),
        "/home/ubuntu/github/google-deepmind/formal-conjectures",
    ]
    for candidate in candidates:
        if not candidate:
            continue
        root = Path(candidate).resolve()
        if (root / "lakefile.toml").is_file() and (root / ".git").is_dir():
            commit = subprocess.run(
                ["git", "-C", str(root), "rev-parse", "HEAD"],
                check=True,
                capture_output=True,
                text=True,
            ).stdout.strip()
            if commit != FORMAL_CONJECTURES_COMMIT:
                raise ValueError(
                    f"Formal Conjectures checkout is {commit}, expected "
                    f"{FORMAL_CONJECTURES_COMMIT}"
                )
            return root
    raise ValueError("pinned Formal Conjectures checkout is unavailable")


def lake_executable() -> str:
    candidates = [
        os.environ.get("FORMAL_CONJECTURES_LAKE"),
        str(
            Path.home()
            / ".elan"
            / "toolchains"
            / "leanprover--lean4---v4.27.0"
            / "bin"
            / "lake"
        ),
        "lake",
    ]
    for candidate in candidates:
        if candidate == "lake" or (candidate and Path(candidate).is_file()):
            return candidate
    raise ValueError("Lean 4.27 Lake executable is unavailable")


def validate_candidate_json(path: Path) -> str:
    candidate = load_json(path)
    if not isinstance(candidate, dict) or set(candidate) != {"answer"}:
        raise ValueError("candidate.json must contain exactly the key `answer`")
    answer = candidate["answer"]
    if answer not in {"true", "false"}:
        raise ValueError("candidate answer must be exactly `true` or `false`")
    return "True" if answer == "true" else "False"


def parse_axioms(output: str) -> set[str]:
    marker = "'Campaign.result' depends on axioms:"
    position = output.rfind(marker)
    if position < 0:
        if "'Campaign.result' does not depend on any axioms" in output:
            return set()
        raise ValueError("Lean output did not contain the trusted #print axioms marker")
    tail = output[position + len(marker) :]
    match = re.search(r"\[([^\]]*)\]", tail)
    if match is None:
        raise ValueError("could not parse Campaign.result axiom list")
    return {item.strip() for item in match.group(1).split(",") if item.strip()}


def verify(manifest_path: Path) -> dict:
    run_directory, artifacts = artifacts_from_manifest(manifest_path)
    answer = validate_candidate_json(artifacts["candidate.json"])
    solution_path = artifacts["solution.lean"]
    solution_bytes = solution_path.read_bytes()
    if len(solution_bytes) > MAX_SOLUTION_BYTES:
        raise ValueError("solution.lean exceeds the 2 MiB verifier limit")
    solution = solution_bytes.decode("utf-8")
    forbidden = FORBIDDEN_SOURCE.search(solution)
    if forbidden is not None:
        raise ValueError(f"forbidden Lean source token: {forbidden.group(0)!r}")

    problem = (run_directory / "problem.md").read_text(encoding="utf-8")
    target = select_target(problem).replace("{answer}", answer).strip()
    trusted_suffix = (
        "\n\n"
        "-- The following verifier-owned commands are not part of the candidate.\n"
        f"example : {target} := Campaign.result\n"
        "#print axioms Campaign.result\n"
    )

    root = formal_conjectures_root()
    lake = lake_executable()
    with tempfile.TemporaryDirectory(prefix="nanocodex-lean-verify-") as temporary:
        check_path = Path(temporary) / "Check.lean"
        check_path.write_text(solution + trusted_suffix, encoding="utf-8")
        completed = subprocess.run(
            [lake, "env", "lean", str(check_path)],
            cwd=root,
            capture_output=True,
            text=True,
            timeout=900,
            env={key: value for key, value in os.environ.items() if key != "OPENAI_API_KEY"},
        )
    combined_output = completed.stdout + "\n" + completed.stderr
    if completed.returncode != 0:
        raise ValueError(f"Lean rejected solution.lean:\n{combined_output[-16000:]}")
    axioms = parse_axioms(combined_output)
    unexpected = sorted(axioms - ALLOWED_AXIOMS)
    if unexpected:
        raise ValueError(f"Campaign.result depends on disallowed axioms: {unexpected}")
    return {
        "accepted": True,
        "answer": answer.lower(),
        "formal_conjectures_commit": FORMAL_CONJECTURES_COMMIT,
        "solution_sha256": hashlib.sha256(solution_bytes).hexdigest(),
        "axioms": sorted(axioms),
        "claim": "Campaign.result has the exact frozen target type and passes pinned Lean verification",
    }


def main() -> int:
    if len(sys.argv) != 2:
        return fail("usage: lean-formal-conjecture.py FROZEN_MANIFEST")
    try:
        result = verify(Path(sys.argv[1]).resolve())
        print(json.dumps(result, sort_keys=True))
        return 0
    except Exception as error:
        return fail(str(error))


if __name__ == "__main__":
    raise SystemExit(main())
