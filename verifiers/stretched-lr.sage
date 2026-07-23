#!/usr/bin/env -S sage --python

import hashlib
import json
import sys
from pathlib import Path

from sage.all import Integer, PolynomialRing, QQ
from sage.libs.lrcalc.lrcalc import lrcoef


MAX_LENGTH = 7
MAX_WEIGHT = 30
DEGREE_BOUND = (MAX_LENGTH - 1) * (MAX_LENGTH - 2) // 2
INTERPOLATION_POINTS = list(range(1, DEGREE_BOUND + 2))
HELD_OUT_POINTS = [DEGREE_BOUND + 2, DEGREE_BOUND + 3]


def fail(message):
    print(json.dumps({"accepted": False, "error": message}), file=sys.stderr)
    return 1


def load_json(path):
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def validate_partition(name, value):
    if not isinstance(value, list) or not value:
        raise ValueError(f"{name} must be a nonempty JSON list")
    if any(type(part) is not int or part <= 0 for part in value):
        raise ValueError(f"{name} must contain positive ordinary integers")
    if value != sorted(value, reverse=True):
        raise ValueError(f"{name} must be weakly decreasing")
    if len(value) > MAX_LENGTH:
        raise ValueError(f"{name} has length greater than {MAX_LENGTH}")
    if sum(value) > MAX_WEIGHT:
        raise ValueError(f"{name} has weight greater than {MAX_WEIGHT}")
    return value


def verify_artifacts(manifest_path, manifest):
    run_directory = manifest_path.parent.parent.resolve()
    candidates = []
    for artifact in manifest.get("artifacts", []):
        relative = artifact.get("path")
        expected = artifact.get("sha256")
        if not isinstance(relative, str) or not isinstance(expected, str):
            raise ValueError("malformed frozen artifact entry")
        path = (run_directory / relative).resolve()
        if run_directory not in path.parents or not path.is_file():
            raise ValueError(f"artifact escapes or is missing: {relative}")
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual != expected:
            raise ValueError(f"artifact hash changed after freeze: {relative}")
        if path.name == "candidate.json":
            candidates.append(path)
    if len(candidates) != 1:
        raise ValueError("frozen manifest must contain exactly one candidate.json")
    return candidates[0]


def stretched_value(lam, mu, nu, stretch):
    outer = [Integer(stretch * part) for part in lam]
    inner1 = [Integer(stretch * part) for part in mu]
    inner2 = [Integer(stretch * part) for part in nu]
    return Integer(lrcoef(outer, inner1, inner2))


def main():
    if len(sys.argv) == 2 and sys.argv[1] == "--self-test":
        if Integer(lrcoef([3, 2, 1], [2, 1], [2, 1])) != 2:
            return fail("lrcalc returned the wrong documented reference coefficient")
        values = [stretched_value([2], [1], [1], stretch) for stretch in INTERPOLATION_POINTS]
        ring = PolynomialRing(QQ, "t")
        polynomial = ring.lagrange_polynomial(
            [(Integer(stretch), value) for stretch, value in zip(INTERPOLATION_POINTS, values)]
        )
        if polynomial != 1 or stretched_value([2], [1], [1], HELD_OUT_POINTS[0]) != 1:
            return fail("interpolation or held-out LR self-test failed")
        print(json.dumps({"accepted": True, "self_test": "ok", "polynomial": str(polynomial)}))
        return 0
    if len(sys.argv) != 2:
        return fail("usage: stretched-lr.sage FROZEN_MANIFEST")
    manifest_path = Path(sys.argv[1]).resolve()
    try:
        manifest = load_json(manifest_path)
        candidate_path = verify_artifacts(manifest_path, manifest)
        candidate = load_json(candidate_path)
        if set(candidate) != {"lambda", "mu", "nu"}:
            raise ValueError("candidate.json must contain exactly lambda, mu, and nu")
        lam = validate_partition("lambda", candidate["lambda"])
        mu = validate_partition("mu", candidate["mu"])
        nu = validate_partition("nu", candidate["nu"])
        if sum(lam) != sum(mu) + sum(nu):
            raise ValueError("partition weights do not satisfy |lambda|=|mu|+|nu|")

        values = [stretched_value(lam, mu, nu, stretch) for stretch in INTERPOLATION_POINTS]
        ring = PolynomialRing(QQ, "t")
        polynomial = ring.lagrange_polynomial(
            [(Integer(stretch), value) for stretch, value in zip(INTERPOLATION_POINTS, values)]
        )
        held_out = {
            stretch: stretched_value(lam, mu, nu, stretch) for stretch in HELD_OUT_POINTS
        }
        for stretch, value in held_out.items():
            if polynomial(Integer(stretch)) != value:
                raise ValueError(
                    f"degree-{DEGREE_BOUND} interpolation failed held-out point t={stretch}"
                )

        coefficients = list(polynomial)
        negative_degrees = [degree for degree, coefficient in enumerate(coefficients) if coefficient < 0]
        if not negative_degrees:
            raise ValueError("exact stretched polynomial has no negative coefficient")

        print(
            json.dumps(
                {
                    "accepted": True,
                    "lambda": lam,
                    "mu": mu,
                    "nu": nu,
                    "degree_bound": DEGREE_BOUND,
                    "interpolation_values": dict(zip(INTERPOLATION_POINTS, map(str, values))),
                    "held_out_values": {str(point): str(value) for point, value in held_out.items()},
                    "polynomial": str(polynomial),
                    "coefficients_low_to_high": [str(coefficient) for coefficient in coefficients],
                    "negative_degrees": negative_degrees,
                },
                sort_keys=True,
            )
        )
        return 0
    except Exception as error:
        return fail(str(error))


sys.exit(int(main()))
