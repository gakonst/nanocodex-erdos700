#!/usr/bin/env python3

"""Targeted bounded falsifier for the structural lemma in proof.md."""

import json

from sympy import primerange


def digitwise_le(left: int, right: int, base: int) -> bool:
    while left or right:
        if left % base > right % base:
            return False
        left //= base
        right //= base
    return True


def omitted(prime: int, n: int, k: int) -> bool:
    return k % prime == 0 and digitwise_le(k // prime, n // prime, prime)


primes = list(primerange(3, 30_000))
prime_set = set(primes)
eligible_triples = 0
pair_multiplier_tests = 0
counterexample = None

for p in primes:
    for a in range(1, 21):
        q = p + a
        if q not in prime_set:
            continue
        for c in range(a + 1, 31):
            r = q + c
            b = a + c
            if r not in prime_set or not p > 4 * b**3:
                continue

            eligible_triples += 1
            n = p * q * r
            for u, v in ((p, q), (p, r), (q, r)):
                # The first digit comparison in each proof case forces
                # t <= a+b or t <= c-a-1. Testing through 2b+2 therefore
                # strictly contains every multiplier that could survive it.
                for t in range(1, 2 * b + 3):
                    pair_multiplier_tests += 1
                    k = u * v * t
                    if (
                        k <= n // 2
                        and omitted(u, n, k)
                        and omitted(v, n, k)
                    ):
                        counterexample = {
                            "p": p,
                            "q": q,
                            "r": r,
                            "a": a,
                            "c": c,
                            "omitted_pair": [u, v],
                            "t": t,
                        }
                        break
                if counterexample is not None:
                    break
            if counterexample is not None:
                break
        if counterexample is not None:
            break
    if counterexample is not None:
        break

print(
    json.dumps(
        {
            "eligible_prime_triples_checked": eligible_triples,
            "pair_multiplier_tests": pair_multiplier_tests,
            "counterexample": counterexample,
        },
        sort_keys=True,
    )
)
