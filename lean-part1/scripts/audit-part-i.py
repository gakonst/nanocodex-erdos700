#!/usr/bin/env python3
"""Independent finite regressions for the Part (i) characterization."""

import math


def factorization(n: int) -> dict[int, int]:
    factors: dict[int, int] = {}
    remaining = n
    prime = 2
    while prime * prime <= remaining:
        while remaining % prime == 0:
            factors[prime] = factors.get(prime, 0) + 1
            remaining //= prime
        prime += 1
    if remaining > 1:
        factors[remaining] = factors.get(remaining, 0) + 1
    return factors


def factorial_valuation(n: int, prime: int) -> int:
    valuation = 0
    while n:
        n //= prime
        valuation += n
    return valuation


def carry_count(n: int, k: int, prime: int) -> int:
    return (
        factorial_valuation(n, prime)
        - factorial_valuation(k, prime)
        - factorial_valuation(n - k, prime)
    )


def boundary_divisors(n: int, factors: dict[int, int]) -> list[int]:
    largest_prime = max(factors)
    return [
        d
        for d in range(largest_prime + 1, n + 1)
        if n % d == 0
        and all(d // prime <= largest_prime for prime in factorization(d))
    ]


def realized_multipliers(
    n: int, d: int, factors: dict[int, int]
) -> list[int]:
    d_factors = factorization(d)
    return [
        m
        for m in range(1, n // (2 * d) + 1)
        if all(
            carry_count(n, d * m, prime) <= factors[prime] - exponent
            for prime, exponent in d_factors.items()
        )
    ]


def boundary_safe(n: int, factors: dict[int, int]) -> bool:
    return all(
        not realized_multipliers(n, d, factors)
        for d in boundary_divisors(n, factors)
    )


def direct_f(n: int) -> int:
    return min(
        math.gcd(n, math.comb(n, k))
        for k in range(2, n // 2 + 1)
    )


def is_composite(factors: dict[int, int]) -> bool:
    return len(factors) > 1 or next(iter(factors.values())) > 1


def main() -> None:
    mandatory = {
        8: {4: [1]},
        30: {6: [], 10: [], 15: []},
        78: {26: [], 39: [1]},
        136: {34: [2]},
    }
    for n, expected in mandatory.items():
        factors = factorization(n)
        actual = {
            d: realized_multipliers(n, d, factors)
            for d in boundary_divisors(n, factors)
        }
        assert actual == expected, (n, actual, expected)

    checked = 0
    for n in range(4, 1001):
        factors = factorization(n)
        if not is_composite(factors):
            continue
        direct = direct_f(n) == n // max(factors)
        characterized = boundary_safe(n, factors)
        assert direct == characterized, (n, direct, characterized)
        checked += 1

    print(
        "Part (i) finite audit passed: "
        f"{checked} composite integers through n=1000 and all mandatory cases."
    )


if __name__ == "__main__":
    main()
