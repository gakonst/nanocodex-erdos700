#!/usr/bin/env python3
"""Independent checks for the 2026-08-03 shared-session Part I claims.

This is a regression checker, not a proof.  It compares the normalized
quotient-spectrum statement with both the boundary criterion and a direct
computation of the complementary carry weights.  It also checks the stated
4q, 6q, 8q, and 9q specializations, the predecessor carry identity, the
historical/maintained baseline split, and retained counterexamples to failed
multiplier-elimination shortcuts.
"""

from __future__ import annotations

import argparse
import math
from itertools import product


def smallest_prime_factors(limit: int) -> list[int]:
    spf = list(range(limit + 1))
    if limit >= 1:
        spf[1] = 1
    for p in range(2, math.isqrt(limit) + 1):
        if spf[p] != p:
            continue
        for multiple in range(p * p, limit + 1, p):
            if spf[multiple] == multiple:
                spf[multiple] = p
    return spf


def factorization(n: int, spf: list[int]) -> dict[int, int]:
    factors: dict[int, int] = {}
    while n > 1:
        p = spf[n]
        exponent = 0
        while n % p == 0:
            exponent += 1
            n //= p
        factors[p] = exponent
    return factors


def divisors(factors: dict[int, int]) -> list[int]:
    powers = [[p**e for e in range(a + 1)] for p, a in factors.items()]
    return sorted(math.prod(choice) for choice in product(*powers))


def valuation(n: int, p: int) -> int:
    result = 0
    while n and n % p == 0:
        result += 1
        n //= p
    return result


def valuation_factorial(n: int, p: int) -> int:
    result = 0
    while n:
        n //= p
        result += n
    return result


def carry_count(n: int, k: int, p: int) -> int:
    assert 0 <= k <= n
    return (
        valuation_factorial(n, p)
        - valuation_factorial(k, p)
        - valuation_factorial(n - k, p)
    )


def boundary_divisors(n: int, factors: dict[int, int], baseline: int) -> list[int]:
    result = []
    for d in divisors(factors):
        if d <= baseline:
            continue
        active_primes = [p for p in factors if d % p == 0]
        if all(d // p <= baseline for p in active_primes):
            result.append(d)
    return result


def boundary_safe(n: int, factors: dict[int, int], baseline: int) -> bool:
    for d in boundary_divisors(n, factors, baseline):
        c = n // d
        for m in range(1, c // 2 + 1):
            if all(
                carry_count(n, d * m, p) <= factors[p] - valuation(d, p)
                for p in factors
                if d % p == 0
            ):
                return False
    return True


def quotient_spectrum_safe(n: int, factors: dict[int, int], baseline: int) -> bool:
    """Normalized version of the shared-session spectrum intersection."""
    for d in boundary_divisors(n, factors, baseline):
        c = n // d
        for m in range(1, c):
            in_every_spectrum = True
            for p in factors:
                if d % p != 0:
                    continue
                exponent = valuation(d, p)
                scale = d // p**exponent
                shortened_n = n // p**exponent
                budget = valuation(c, p)
                if carry_count(shortened_n, scale * m, p) > budget:
                    in_every_spectrum = False
                    break
            if in_every_spectrum:
                return False
    return True


def direct_target_equality(n: int, factors: dict[int, int], baseline: int) -> bool:
    maximum_weight = 1
    for k in range(2, n // 2 + 1):
        weight = math.prod(
            p ** max(exponent - carry_count(n, k, p), 0)
            for p, exponent in factors.items()
        )
        maximum_weight = max(maximum_weight, weight)
    return maximum_weight == baseline


def is_power(n: int, base: int) -> bool:
    if n < 1:
        return False
    while n % base == 0:
        n //= base
    return n == 1


def has_adjacent_binary_ones(n: int) -> bool:
    return (n & (n >> 1)) != 0


def has_ternary_digit_two(n: int) -> bool:
    while n:
        if n % 3 == 2:
            return True
        n //= 3
    return False


def check_low_digit_carry_identity() -> int:
    """Check the exact carry formula used by the cofactor theorem."""
    checked = 0
    for p in (2, 3, 5, 7):
        for a_value in range(2, 100):
            for m in range(1, a_value):
                for width in range(2, 12):
                    modulus = p**width
                    if modulus <= a_value:
                        continue
                    multiplier = modulus - 1
                    low_carries = sum(
                        (m * multiplier) % p**digit > (a_value * multiplier) % p**digit
                        for digit in range(1, width + 1)
                    )
                    predicted = (
                        width
                        - carry_count(a_value, m, p)
                        - valuation(m, p)
                        - valuation(a_value - m, p)
                        + valuation(a_value, p)
                    )
                    assert low_carries == predicted, (
                        p,
                        a_value,
                        m,
                        width,
                        low_carries,
                        predicted,
                    )
                    checked += 1
    return checked


def check_predecessor_carry_identity() -> int:
    """Check the exact local identity isolating v_p(m) as the budget."""
    checked = 0
    for p in (2, 3, 5, 7):
        for scale in range(1, 31):
            if scale % p == 0:
                continue
            for cofactor in range(2, 31):
                for m in range(1, cofactor):
                    shortened_n = scale * cofactor
                    shortened_k = scale * m
                    predicted = (
                        valuation(cofactor, p)
                        - valuation(m, p)
                        + carry_count(
                            shortened_n - 1,
                            shortened_k - 1,
                            p,
                        )
                    )
                    assert carry_count(shortened_n, shortened_k, p) == predicted
                    checked += 1
    return checked


def check_all_n(limit: int) -> tuple[int, int]:
    spf = smallest_prime_factors(limit)
    modern_checked = 0
    historical_checked = 0
    for n in range(4, limit + 1):
        factors = factorization(n, spf)
        if len(factors) == 1 and next(iter(factors.values())) == 1:
            continue

        largest_prime = max(factors)
        modern = direct_target_equality(n, factors, largest_prime)
        boundary = boundary_safe(n, factors, largest_prime)
        spectrum = quotient_spectrum_safe(n, factors, largest_prime)
        assert modern == boundary == spectrum, (
            "modern",
            n,
            factors,
            modern,
            boundary,
            spectrum,
        )
        modern_checked += 1

        if len(factors) > 1:
            greatest_component = max(p**a for p, a in factors.items())
            historical = direct_target_equality(n, factors, greatest_component)
            boundary = boundary_safe(n, factors, greatest_component)
            spectrum = quotient_spectrum_safe(n, factors, greatest_component)
            assert historical == boundary == spectrum, (
                "historical",
                n,
                factors,
                historical,
                boundary,
                spectrum,
            )
            historical_checked += 1
    return modern_checked, historical_checked


def check_special_families(prime_limit: int) -> dict[str, int]:
    spf = smallest_prime_factors(9 * prime_limit)
    counts = {"4q": 0, "6q": 0, "8q": 0, "9q": 0}
    for q in range(3, prime_limit + 1):
        if spf[q] != q:
            continue
        if q > 4:
            factors = {2: 2, q: 1}
            assert boundary_safe(4 * q, factors, q)
            counts["4q"] += 1
        if q > 6:
            factors = {2: 1, 3: 1, q: 1}
            expected = has_adjacent_binary_ones(q) and has_ternary_digit_two(q)
            assert boundary_safe(6 * q, factors, q) == expected, ("6q", q)
            counts["6q"] += 1
        if q > 8:
            factors = {2: 3, q: 1}
            expected = not (is_power(q - 1, 2) or is_power(3 * q - 1, 2))
            assert boundary_safe(8 * q, factors, q) == expected, ("8q", q)
            counts["8q"] += 1
        if q > 9:
            factors = {3: 2, q: 1}
            expected = not is_power(2 * q - 1, 3)
            assert boundary_safe(9 * q, factors, q) == expected, ("9q", q)
            counts["9q"] += 1
    return counts


def local_multiplier_sets(
    n: int, factors: dict[int, int], d: int
) -> tuple[int, dict[int, list[int]]]:
    """Return each active prime's accepted multipliers, before intersection."""
    multiplier_limit = (n // d) // 2
    accepted = {
        p: [
            m
            for m in range(1, multiplier_limit + 1)
            if carry_count(n, d * m, p) <= factors[p] - valuation(d, p)
        ]
        for p in factors
        if d % p == 0
    }
    return multiplier_limit, accepted


def check_focused_regressions() -> tuple[int, int]:
    """Pin the baseline split and failed multiplier-elimination shortcuts."""
    spf = smallest_prime_factors(2_000)

    # (n, historical equality, maintained equality)
    expected_statuses = (
        (8, False, False),
        (12, True, False),
        (18, True, False),
        (30, True, True),
        (40, True, False),
        (78, False, False),
        (120, False, False),
        (136, False, False),
        (150, True, False),
        (195, False, False),
        (1_470, False, False),
        (1_694, False, False),
    )
    for n, expected_historical, expected_maintained in expected_statuses:
        factors = factorization(n, spf)
        historical_baseline = max(p**a for p, a in factors.items())
        maintained_baseline = max(factors)
        assert (
            direct_target_equality(n, factors, historical_baseline)
            == expected_historical
        ), ("historical regression", n)
        assert (
            direct_target_equality(n, factors, maintained_baseline)
            == expected_maintained
        ), ("maintained regression", n)
        if len(factors) > 1:
            assert boundary_safe(n, factors, historical_baseline) == (
                expected_historical
            ), ("historical boundary regression", n)
        else:
            # Composite prime powers are the separate historical exception:
            # Q(n)=n and the boundary predicate is vacuous, but f(n)>1.
            assert boundary_safe(n, factors, historical_baseline)
            assert not expected_historical
        assert boundary_safe(n, factors, maintained_baseline) == (
            expected_maintained
        ), ("maintained boundary regression", n)

    factors_12 = factorization(12, spf)
    assert max(p**a for p, a in factors_12.items()) == 4
    assert max(factors_12) == 3

    # The quotient-spectrum equivalence requires a witnessed baseline (in the
    # applications, a proper prime-power divisor), not an arbitrary divisor.
    factors_30 = factorization(30, spf)
    assert quotient_spectrum_safe(30, factors_30, 6)
    assert not direct_target_equality(30, factors_30, 6)

    # Independent local solvability does not imply a shared multiplier.
    factors_40 = factorization(40, spf)
    limit_40, sets_40 = local_multiplier_sets(40, factors_40, 10)
    assert limit_40 == 2
    assert sets_40 == {2: [2], 5: [1]}
    assert not set.intersection(*(set(values) for values in sets_40.values()))

    # The first shared multiplier need not be any primewise least multiplier.
    factors_120 = factorization(120, spf)
    limit_120, sets_120 = local_multiplier_sets(120, factors_120, 12)
    assert limit_120 == 5
    assert sets_120 == {2: [2, 3, 4], 3: [1, 3]}
    common_120 = set.intersection(*(set(values) for values in sets_120.values()))
    assert common_120 == {3}
    assert all(min(values) not in common_120 for values in sets_120.values())

    # Testing only m=1 is false even for two exact components.
    factors_136 = factorization(136, spf)
    _, sets_136 = local_multiplier_sets(136, factors_136, 34)
    common_136 = set.intersection(*(set(values) for values in sets_136.values()))
    assert common_136 == {2}

    # Pairwise compatibility of three active prime-base conditions is not
    # sufficient for simultaneous compatibility.
    factors_1470 = factorization(1_470, spf)
    limit_1470, sets_1470 = local_multiplier_sets(1_470, factors_1470, 70)
    assert limit_1470 == 10
    assert sets_1470 == {
        2: [2, 4, 6],
        5: [1, 2, 3, 9, 10],
        7: [1, 5, 6, 7, 10],
    }
    primes_1470 = tuple(sets_1470)
    assert all(
        set(sets_1470[primes_1470[i]]) & set(sets_1470[primes_1470[j]])
        for i in range(len(primes_1470))
        for j in range(i + 1, len(primes_1470))
    )
    assert not set.intersection(*(set(values) for values in sets_1470.values()))

    # The n=195 witness is primitive for divisor/cofactor descent: m=2 is
    # coprime to n and the cofactor n/d=13 is prime.
    factors_195 = factorization(195, spf)
    _, sets_195 = local_multiplier_sets(195, factors_195, 15)
    common_195 = set.intersection(*(set(values) for values in sets_195.values()))
    assert common_195 == {2}
    assert math.gcd(2, 195) == 1
    assert spf[195 // 15] == 195 // 15

    # No reduction to at most two active prime bases is possible: for the
    # historical baseline Q(1694)=121, only d=154 is realized, and its active
    # support is {2,7,11}.
    factors_1694 = factorization(1_694, spf)
    historical_baseline_1694 = max(p**a for p, a in factors_1694.items())
    assert historical_baseline_1694 == 121
    realized_boundaries = []
    for d in boundary_divisors(1_694, factors_1694, historical_baseline_1694):
        _, local_sets = local_multiplier_sets(1_694, factors_1694, d)
        common = set.intersection(*(set(values) for values in local_sets.values()))
        if common:
            realized_boundaries.append((d, tuple(local_sets), min(common)))
    assert realized_boundaries == [(154, (2, 7, 11), 1)]

    # Deleting an inactive cofactor component does not preserve realization.
    factors_210 = {2: 1, 3: 1, 5: 1, 7: 1}
    _, sets_210 = local_multiplier_sets(210, factors_210, 10)
    assert set.intersection(*(set(values) for values in sets_210.values())) == {8}
    for smaller_n, smaller_factors in (
        (30, {2: 1, 3: 1, 5: 1}),
        (70, {2: 1, 5: 1, 7: 1}),
    ):
        _, smaller_sets = local_multiplier_sets(smaller_n, smaller_factors, 10)
        assert not set.intersection(*(set(values) for values in smaller_sets.values()))

    # A primitive common witness can occur very late in the cofactor interval.
    factors_6006 = {2: 1, 3: 1, 7: 1, 11: 1, 13: 1}
    _, sets_6006 = local_multiplier_sets(6_006, factors_6006, 21)
    assert set.intersection(*(set(values) for values in sets_6006.values())) == {139}
    assert math.gcd(139, 6_006) == 1

    # A larger all-zero-budget example confirms that pairwise compatibility
    # can coexist with global safety of every historical boundary.
    factors_10605 = {3: 1, 5: 1, 7: 1, 101: 1}
    _, sets_10605 = local_multiplier_sets(10_605, factors_10605, 105)
    primes_10605 = tuple(sets_10605)
    assert all(
        set(sets_10605[primes_10605[i]]) & set(sets_10605[primes_10605[j]])
        for i in range(len(primes_10605))
        for j in range(i + 1, len(primes_10605))
    )
    assert not set.intersection(*(set(values) for values in sets_10605.values()))
    assert boundary_safe(10_605, factors_10605, 101)

    # Changing only the largest prime from 101 to 103 changes the preceding
    # safe triple-cylinder pattern to a unique common multiplier m=31.
    factors_10815 = {3: 1, 5: 1, 7: 1, 103: 1}
    _, sets_10815 = local_multiplier_sets(10_815, factors_10815, 105)
    assert set.intersection(*(set(values) for values in sets_10815.values())) == {31}
    assert not boundary_safe(10_815, factors_10815, 103)

    # Divisibility descent on the witness fails: the unique m=4100 works,
    # while each of its proper divisors does not.
    factors_180880 = {2: 4, 5: 1, 7: 1, 17: 1, 19: 1}
    _, sets_180880 = local_multiplier_sets(180_880, factors_180880, 20)
    common_180880 = set.intersection(*(set(values) for values in sets_180880.values()))
    assert common_180880 == {4_100}
    proper_divisors_4100 = divisors({2: 2, 5: 2, 41: 1})[:-1]
    assert all(m not in common_180880 for m in proper_divisors_4100)

    # A fixed menu containing only the first 651 multipliers is insufficient.
    factors_1904299 = {31: 1, 47: 1, 1_307: 1}
    _, sets_1904299 = local_multiplier_sets(1_904_299, factors_1904299, 1_457)
    assert set.intersection(*(set(values) for values in sets_1904299.values())) == {652}

    return len(expected_statuses), 12


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--all-n-limit", type=int, default=5_000)
    parser.add_argument("--prime-limit", type=int, default=100_000)
    args = parser.parse_args()

    modern, historical = check_all_n(args.all_n_limit)
    families = check_special_families(args.prime_limit)
    carry_identity_cases = check_low_digit_carry_identity()
    predecessor_identity_cases = check_predecessor_carry_identity()
    focused_regressions, shortcut_counterexamples = check_focused_regressions()
    print(f"all_n_limit={args.all_n_limit}")
    print(f"modern_composites_checked={modern}")
    print(f"historical_non_prime_powers_checked={historical}")
    print(f"prime_limit={args.prime_limit}")
    for family, count in families.items():
        print(f"{family}_primes_checked={count}")
    print(f"cofactor_carry_identity_cases_checked={carry_identity_cases}")
    print(f"predecessor_identity_cases_checked={predecessor_identity_cases}")
    print(f"focused_regressions_checked={focused_regressions}")
    print(f"shortcut_counterexamples_checked={shortcut_counterexamples}")


if __name__ == "__main__":
    main()
