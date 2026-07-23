#!/usr/bin/env python3

"""Verify a frozen 40-vertex witness proving R(3, 10) >= 41."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path


ORDER = 40
INDEPENDENCE_LIMIT = 9
ALL_VERTICES = (1 << ORDER) - 1


def fail(message: str) -> int:
    print(json.dumps({"accepted": False, "error": message}), file=sys.stderr)
    return 1


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def candidate_from_manifest(manifest_path: Path) -> Path:
    manifest = load_json(manifest_path)
    run_directory = manifest_path.parent.parent.resolve()
    candidates: list[Path] = []
    for artifact in manifest.get("artifacts", []):
        relative = artifact.get("path")
        expected = artifact.get("sha256")
        if not isinstance(relative, str) or not isinstance(expected, str):
            raise ValueError("malformed frozen artifact entry")
        path = (run_directory / relative).resolve()
        if run_directory not in path.parents or not path.is_file():
            raise ValueError(f"artifact escapes or is missing: {relative}")
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError(f"artifact hash changed after freeze: {relative}")
        if path.name == "candidate.json":
            candidates.append(path)
    if len(candidates) != 1:
        raise ValueError("frozen manifest must contain exactly one candidate.json")
    return candidates[0]


def decode_graph(candidate):
    if not isinstance(candidate, dict) or set(candidate) != {"n", "edges"}:
        raise ValueError("candidate.json must contain exactly n and edges")
    if type(candidate["n"]) is not int or candidate["n"] != ORDER:
        raise ValueError(f"n must be the ordinary integer {ORDER}")
    if not isinstance(candidate["edges"], list):
        raise ValueError("edges must be a JSON list")

    adjacency = [0] * ORDER
    normalized: set[tuple[int, int]] = set()
    for index, edge in enumerate(candidate["edges"]):
        if not isinstance(edge, list) or len(edge) != 2:
            raise ValueError(f"edge {index} must be a two-element JSON list")
        u, v = edge
        if type(u) is not int or type(v) is not int:
            raise ValueError(f"edge {index} endpoints must be ordinary integers")
        if not (0 <= u < v < ORDER):
            raise ValueError(f"edge {index} must satisfy 0 <= u < v < {ORDER}")
        if (u, v) in normalized:
            raise ValueError(f"duplicate edge {(u, v)}")
        normalized.add((u, v))
        adjacency[u] |= 1 << v
        adjacency[v] |= 1 << u
    return adjacency, normalized


def triangle(adjacency: list[int]):
    for u in range(ORDER):
        later = adjacency[u] & ~((1 << (u + 1)) - 1)
        while later:
            bit = later & -later
            v = bit.bit_length() - 1
            common = adjacency[u] & adjacency[v] & ~((1 << (v + 1)) - 1)
            if common:
                w = (common & -common).bit_length() - 1
                return [u, v, w]
            later ^= bit
    return None


def greedy_color_order(vertices: int, adjacency: list[int]):
    """Return a Tomita-style order and clique upper bound for each prefix."""

    order: list[int] = []
    bounds: list[int] = []
    remaining = vertices
    color = 0
    while remaining:
        color += 1
        available = remaining
        while available:
            bit = available & -available
            vertex = bit.bit_length() - 1
            order.append(vertex)
            bounds.append(color)
            remaining ^= bit
            available ^= bit
            available &= ~adjacency[vertex]
    return order, bounds


def find_clique(adjacency: list[int], target: int):
    """Return one target-clique, or None after an exact branch-and-bound search."""

    witness: list[int] | None = None

    def expand(vertices: int, chosen: list[int]) -> bool:
        nonlocal witness
        order, bounds = greedy_color_order(vertices, adjacency)
        for index in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[index] < target:
                return False
            vertex = order[index]
            bit = 1 << vertex
            if not vertices & bit:
                continue
            extended = chosen + [vertex]
            if len(extended) == target:
                witness = sorted(extended)
                return True
            next_vertices = vertices & adjacency[vertex]
            if next_vertices.bit_count() >= target - len(extended):
                if expand(next_vertices, extended):
                    return True
            vertices ^= bit
        return False

    expand(ALL_VERTICES, [])
    return witness


def verify_candidate(candidate):
    adjacency, edges = decode_graph(candidate)
    found_triangle = triangle(adjacency)
    if found_triangle is not None:
        raise ValueError(f"graph contains triangle {found_triangle}")

    complement = [ALL_VERTICES & ~(adjacency[v] | (1 << v)) for v in range(ORDER)]
    independent = find_clique(complement, INDEPENDENCE_LIMIT + 1)
    if independent is not None:
        raise ValueError(f"graph contains independent 10-set {independent}")

    degrees = [neighbors.bit_count() for neighbors in adjacency]
    return {
        "accepted": True,
        "n": ORDER,
        "edges": len(edges),
        "minimum_degree": min(degrees),
        "maximum_degree": max(degrees),
        "triangle_free": True,
        "independence_number_at_most": INDEPENDENCE_LIMIT,
        "claim": "R(3,10) >= 41; combined with the published upper bound, R(3,10)=41",
    }


def self_test() -> None:
    cycle_edges = [[u, (u + 1) % 5] for u in range(5)]
    cycle_edges = [[min(u, v), max(u, v)] for u, v in cycle_edges]
    cycle = {"n": ORDER, "edges": cycle_edges}
    adjacency, _ = decode_graph(cycle)
    complement = [ALL_VERTICES & ~(adjacency[v] | (1 << v)) for v in range(ORDER)]
    # Vertices 5..39 are isolated in the padded graph, hence independent.
    if find_clique(complement, 10) is None:
        raise AssertionError("independent-set positive self-test failed")

    complete_edges = [[u, v] for u in range(ORDER) for v in range(u + 1, ORDER)]
    complete, _ = decode_graph({"n": ORDER, "edges": complete_edges})
    if triangle(complete) != [0, 1, 2]:
        raise AssertionError("triangle positive self-test failed")

    # Check the clique engine on small induced graphs independently of ORDER.
    small = [0] * ORDER
    for u in range(4):
        for v in range(u + 1, 4):
            small[u] |= 1 << v
            small[v] |= 1 << u
    if find_clique(small, 4) != [0, 1, 2, 3] or find_clique(small, 5) is not None:
        raise AssertionError("exact clique-engine self-test failed")


def main() -> int:
    if len(sys.argv) == 2 and sys.argv[1] == "--self-test":
        try:
            self_test()
            print(json.dumps({"accepted": True, "self_test": "ok"}))
            return 0
        except Exception as error:
            return fail(str(error))
    if len(sys.argv) != 2:
        return fail("usage: ramsey-r3-10.py FROZEN_MANIFEST")
    try:
        manifest_path = Path(sys.argv[1]).resolve()
        candidate_path = candidate_from_manifest(manifest_path)
        result = verify_candidate(load_json(candidate_path))
        result["candidate_sha256"] = hashlib.sha256(candidate_path.read_bytes()).hexdigest()
        print(json.dumps(result, sort_keys=True))
        return 0
    except Exception as error:
        return fail(str(error))


if __name__ == "__main__":
    raise SystemExit(main())
