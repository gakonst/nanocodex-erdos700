#!/usr/bin/env python3
"""Search exact rows on structurally hard Erdős 700(iii) residuals.

This is a game-selection instrument, not a verifier for the asymptotic
theorem.  Every reported row score is exact.  Instances are retained only
when they satisfy the strict component cap and high-height mass condition
used by the current residual reduction.
"""

from __future__ import annotations

import argparse
import json
import math
import random
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


@dataclass(frozen=True)
class Component:
    prime: int
    exponent: int

    @property
    def value(self) -> int:
        return self.prime**self.exponent


@dataclass
class ScoredRow:
    k: int
    origin: str
    log_depth: float
    depths: list[tuple[int, int, int]]

    @property
    def support(self) -> int:
        return sum(depth > 0 for _, _, depth in self.depths)

    @property
    def total_depth(self) -> int:
        return sum(depth for _, _, depth in self.depths)

    @property
    def max_depth(self) -> int:
        return max((depth for _, _, depth in self.depths), default=0)


def primes_up_to(limit: int) -> list[int]:
    sieve = bytearray(b"\x01") * (limit + 1)
    if limit >= 0:
        sieve[0] = 0
    if limit >= 1:
        sieve[1] = 0
    for p in range(2, math.isqrt(limit) + 1):
        if sieve[p]:
            start = p * p
            sieve[start : limit + 1 : p] = b"\x00" * (
                (limit - start) // p + 1
            )
    return [p for p in range(2, limit + 1) if sieve[p]]


def build_components(
    primes: list[int], family: str, a_value: float
) -> list[Component]:
    if family == "squarefree":
        return [Component(p, 1) for p in primes]
    if family == "layered":
        max_height = max(1, math.floor(a_value))
        return [
            Component(p, 1 + (index % max_height))
            for index, p in enumerate(primes)
        ]
    raise ValueError(f"unknown family: {family}")


def product(values: Iterable[int]) -> int:
    result = 1
    for value in values:
        result *= value
    return result


def log_int(value: int) -> float:
    """Return log(value) without converting a large integer to float."""
    if value <= 0:
        raise ValueError("log_int requires a positive integer")
    bits = value.bit_length()
    if bits <= 53:
        return math.log(value)
    shift = bits - 53
    return math.log(value >> shift) + shift * math.log(2.0)


def binomial_vp_capped(n: int, k: int, p: int, cap: int) -> int:
    """Return min(cap, v_p(binomial(n, k))) exactly."""
    if k < 0 or k > n:
        raise ValueError("k must lie in [0,n]")
    valuation = 0
    power = p
    complement = n - k
    while power <= n and valuation < cap:
        valuation += n // power - k // power - complement // power
        power *= p
    return min(cap, valuation)


def score_row(n: int, components: list[Component], k: int, origin: str) -> ScoredRow:
    depths: list[tuple[int, int, int]] = []
    log_depth = 0.0
    for component in components:
        loss = binomial_vp_capped(
            n, k, component.prime, component.exponent
        )
        depth = component.exponent - loss
        depths.append((component.prime, component.exponent, depth))
        log_depth += depth * math.log(component.prime)
    return ScoredRow(k=k, origin=origin, log_depth=log_depth, depths=depths)


def instance_metadata(
    n: int, components: list[Component], a_value: float
) -> dict[str, object]:
    x = sum(component.exponent * math.log(component.prime) for component in components)
    m = math.ceil(a_value)
    h = math.floor(a_value) + 1
    delta = 1.0 / (16.0 * a_value)
    gamma = delta**m
    cap = gamma * (x**a_value)
    q_max = max(component.value for component in components)
    high_mass = sum(
        component.exponent * math.log(component.prime)
        for component in components
        if component.exponent >= h
    )
    low = [component for component in components if component.exponent < h]
    ordered_low = sorted(low, key=lambda component: component.prime)
    upper = ordered_low[len(ordered_low) // 2 :]
    strict_cap = q_max < cap
    high_mass_ok = high_mass < x / 2.0
    return {
        "A": a_value,
        "m": m,
        "h": h,
        "delta": delta,
        "gamma": gamma,
        "X": x,
        "log_X": math.log(x),
        "decimal_digits_n": int(x / math.log(10.0)) + 1,
        "component_count": len(components),
        "q_max": q_max,
        "component_cap": cap,
        "strict_component_cap": strict_cap,
        "high_height_log_mass": high_mass,
        "high_height_mass_ok": high_mass_ok,
        "upper_half_count": len(upper),
        "upper_half_min_prime": min(
            (component.prime for component in upper), default=None
        ),
        "upper_half_above_delta_X": all(
            component.prime > delta * x for component in upper
        ),
        "target_log_depth": a_value * math.log(x),
        "n_bit_length": n.bit_length(),
    }


def random_subset_product(
    rng: random.Random,
    components: list[Component],
    width: int,
    full_components: bool,
) -> int:
    chosen = rng.sample(components, min(width, len(components)))
    if full_components:
        return product(component.value for component in chosen)
    return product(component.prime for component in chosen)


def candidate_rows(
    n: int,
    components: list[Component],
    a_value: float,
    rng: random.Random,
    samples: int,
) -> list[tuple[int, str]]:
    half = n // 2
    m = math.ceil(a_value)
    ordered = sorted(components, key=lambda component: component.prime)
    upper = ordered[len(ordered) // 2 :]
    rows: dict[int, str] = {}

    def add(k: int, origin: str) -> None:
        if 2 <= k <= half and k not in rows:
            rows[k] = origin

    for component in upper[-min(24, len(upper)) :]:
        add(component.prime, "single-base")
        add(component.value, "single-component")
        add(n // component.value, "component-cofactor")

    for width in range(1, min(m + 3, len(upper)) + 1):
        for _ in range(max(8, samples // (4 * (m + 2)))):
            base_product = random_subset_product(
                rng, upper, width, full_components=False
            )
            component_product = random_subset_product(
                rng, upper, width, full_components=True
            )
            add(base_product, f"base-product-{width}")
            add(component_product, f"component-product-{width}")
            if base_product <= half:
                max_t = half // base_product
                add(
                    base_product * rng.randint(1, max_t),
                    f"base-product-random-multiplier-{width}",
                )
                add(
                    base_product * rng.randint(1, min(max_t, 1 << 24)),
                    f"base-product-small-multiplier-{width}",
                )

    for _ in range(samples):
        add(rng.randint(2, half), "uniform")
        offset = rng.randint(0, min(half - 2, 1 << 32))
        add(half - offset, "near-midpoint")

        divisor_components = [
            component.value
            for component in components
            if rng.random() < 0.08
        ]
        if divisor_components:
            divisor = product(divisor_components)
            add(divisor, "random-divisor")
            add(n // divisor, "random-divisor-cofactor")

    return list(rows.items())


def hill_climb(
    n: int,
    components: list[Component],
    seeds: list[ScoredRow],
    rng: random.Random,
    rounds: int,
    beam_width: int,
) -> list[ScoredRow]:
    half = n // 2
    beam = sorted(seeds, key=lambda row: row.log_depth, reverse=True)[:beam_width]
    cache = {row.k: row for row in seeds}
    primes = [component.prime for component in components]

    for round_index in range(rounds):
        proposals: dict[int, str] = {}
        for row in beam:
            for _ in range(12):
                p = rng.choice(primes)
                mode = rng.randrange(6)
                if mode == 0:
                    k = row.k * p
                elif mode == 1:
                    k = row.k // p if row.k % p == 0 else row.k
                elif mode == 2:
                    k = row.k + p * rng.randint(1, 1 << 16)
                elif mode == 3:
                    k = row.k - p * rng.randint(1, 1 << 16)
                elif mode == 4:
                    k = n - row.k
                else:
                    width = rng.randint(1, min(4, len(components)))
                    step = random_subset_product(
                        rng, components, width, full_components=False
                    )
                    multiplier = rng.randint(-32, 32)
                    k = row.k + multiplier * step
                if 2 <= k <= half and k not in cache:
                    proposals[k] = (
                        f"hill-{round_index}-{mode}<-{row.origin}"
                    )

        for k, origin in proposals.items():
            cache[k] = score_row(n, components, k, origin)
        beam = sorted(
            [*beam, *(cache[k] for k in proposals)],
            key=lambda row: row.log_depth,
            reverse=True,
        )[:beam_width]
    return beam


def summarize_row(
    row: ScoredRow,
    target: float,
    n: int,
    components: list[Component],
) -> dict[str, object]:
    positive = [
        {"p": p, "a": exponent, "depth": depth}
        for p, exponent, depth in row.depths
        if depth > 0
    ]
    positive.sort(key=lambda item: item["depth"] * math.log(item["p"]), reverse=True)
    remainder = row.k
    row_factors = []
    for component in components:
        exponent = 0
        while remainder % component.prime == 0:
            exponent += 1
            remainder //= component.prime
        if exponent:
            row_factors.append({"p": component.prime, "exponent": exponent})
    return {
        "origin": row.origin,
        "k_bit_length": row.k.bit_length(),
        "log_k_over_n": log_int(row.k) - log_int(n),
        "row_n_prime_factors": row_factors,
        "row_external_cofactor_bit_length": remainder.bit_length(),
        "row_external_cofactor_is_one": remainder == 1,
        "log_D": row.log_depth,
        "target_log_D": target,
        "target_ratio": row.log_depth / target if target else math.inf,
        "support": row.support,
        "total_depth": row.total_depth,
        "max_depth": row.max_depth,
        "top_contributors": positive[:24],
    }


def run_instance(
    a_value: float,
    prime_limit: int,
    family: str,
    seed: int,
    samples: int,
    hill_rounds: int,
    beam_width: int,
) -> dict[str, object]:
    primes = primes_up_to(prime_limit)
    components = build_components(primes, family, a_value)
    n = product(component.value for component in components)
    metadata = instance_metadata(n, components, a_value)
    result: dict[str, object] = {
        "family": family,
        "prime_limit": prime_limit,
        "metadata": metadata,
    }
    if not (
        metadata["strict_component_cap"]
        and metadata["high_height_mass_ok"]
        and metadata["upper_half_above_delta_X"]
    ):
        result["status"] = "rejected-by-residual-gate"
        return result

    rng = random.Random(seed)
    candidates = candidate_rows(n, components, a_value, rng, samples)
    scored = [
        score_row(n, components, k, origin)
        for k, origin in candidates
    ]
    beam = hill_climb(
        n,
        components,
        scored,
        rng,
        rounds=hill_rounds,
        beam_width=beam_width,
    )
    best = sorted(
        [*scored, *beam], key=lambda row: row.log_depth, reverse=True
    )
    unique: list[ScoredRow] = []
    seen: set[int] = set()
    for row in best:
        if row.k not in seen:
            seen.add(row.k)
            unique.append(row)
        if len(unique) == 20:
            break
    target = float(metadata["target_log_depth"])
    result.update(
        {
            "status": "searched",
            "seed": seed,
            "candidate_count": len(scored),
            "hill_rounds": hill_rounds,
            "beam_width": beam_width,
            "best_rows": [
                summarize_row(
                    row,
                    target=target,
                    n=n,
                    components=components,
                )
                for row in unique
            ],
        }
    )
    return result


def parse_csv_numbers(raw: str, converter) -> list:
    return [converter(item.strip()) for item in raw.split(",") if item.strip()]


def render_markdown(results: list[dict[str, object]]) -> str:
    lines = [
        "# Erdős 700(iii) extremal-instance laboratory",
        "",
        "Every row score below is exact. The search is diagnostic and is not",
        "evidence for an asymptotic theorem.",
        "",
        "| A | family | prime limit | gate | candidates | best ratio | support | depth | origin |",
        "|---:|---|---:|---|---:|---:|---:|---:|---|",
    ]
    for result in results:
        metadata = result["metadata"]
        best_rows = result.get("best_rows", [])
        best = best_rows[0] if best_rows else {}
        lines.append(
            "| {A} | {family} | {limit} | {status} | {count} | {ratio} | "
            "{support} | {depth} | {origin} |".format(
                A=metadata["A"],
                family=result["family"],
                limit=result["prime_limit"],
                status=result["status"],
                count=result.get("candidate_count", 0),
                ratio=(
                    f"{best['target_ratio']:.3f}" if best else "—"
                ),
                support=best.get("support", "—"),
                depth=best.get("total_depth", "—"),
                origin=best.get("origin", "—"),
            )
        )
    lines.extend(
        [
            "",
            "The JSON companion contains the exact residual gates and the top",
            "weighted-depth contributors for every retained row.",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--a-values", default="2,2.5,3")
    parser.add_argument("--prime-limits", default="1200,1800,2600")
    parser.add_argument(
        "--families", default="squarefree,layered"
    )
    parser.add_argument("--samples", type=int, default=160)
    parser.add_argument("--hill-rounds", type=int, default=10)
    parser.add_argument("--beam-width", type=int, default=12)
    parser.add_argument("--seed", type=int, default=700)
    parser.add_argument("--output-json", type=Path, required=True)
    parser.add_argument("--output-md", type=Path, required=True)
    args = parser.parse_args()

    a_values = parse_csv_numbers(args.a_values, float)
    limits = parse_csv_numbers(args.prime_limits, int)
    families = parse_csv_numbers(args.families, str)
    if len(limits) not in (1, len(a_values)):
        raise SystemExit(
            "--prime-limits must have one value or one per A value"
        )
    if len(limits) == 1:
        limits *= len(a_values)

    results = []
    for index, (a_value, limit) in enumerate(zip(a_values, limits, strict=True)):
        for family in families:
            results.append(
                run_instance(
                    a_value=a_value,
                    prime_limit=limit,
                    family=family,
                    seed=args.seed + index * 1009,
                    samples=args.samples,
                    hill_rounds=args.hill_rounds,
                    beam_width=args.beam_width,
                )
            )

    args.output_json.parent.mkdir(parents=True, exist_ok=True)
    args.output_md.parent.mkdir(parents=True, exist_ok=True)
    args.output_json.write_text(
        json.dumps(results, indent=2, sort_keys=True) + "\n"
    )
    args.output_md.write_text(render_markdown(results))


if __name__ == "__main__":
    main()
