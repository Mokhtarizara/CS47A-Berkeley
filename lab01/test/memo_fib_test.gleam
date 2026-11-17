//// Tests for `fib_memoized` and `fib_passing`: that they compute Fibonacci
//// numbers, that they store them in the cache, and that they never compute
//// the same Fibonacci number twice.

import gleam/dict
import lab01.{type Cache, fib_memoized, fib_passing}

/// Run fib_memoized starting from an empty cache and return its value and cache.
fn run_fib_memoized(n: Int) -> #(Int, Cache) {
  fib_memoized(n, dict.new())
}

/// Run fib_passing starting from an empty cache and return its value and cache.
fn run_fib_passing(n: Int) -> #(Int, Cache) {
  fib_passing(n)(dict.new())
}

pub fn fib_memoized_test() -> Nil {
  check_fib_values(run_fib_memoized)
  check_fib_storage(run_fib_memoized)
  check_fib_large(run_fib_memoized)
}

pub fn fib_passing_test() -> Nil {
  check_fib_values(run_fib_passing)
  check_fib_storage(run_fib_passing)
  check_fib_large(run_fib_passing)
}

fn check_fib_values(fib: fn(Int) -> #(Int, Cache)) -> Nil {
  let fib_value = fn(n: Int) -> Int { fib(n).0 }
  assert fib_value(0) == 0 as "The 0th Fibonacci number is 0"
  assert fib_value(1) == 1 as "The 1st Fibonacci number is 1"
  assert fib_value(2) == 1
    as "The 2nd Fibonacci number is fib(0) + fib(1) = 0 + 1 = 1"
  assert fib_value(3) == 2
    as "The 3rd Fibonacci number is fib(1) + fib(2) = 1 + 1 = 2"
  assert fib_value(10) == 55 as "The 10th Fibonacci number is 55"
  assert fib_value(20) == 6765 as "The 20th Fibonacci number is 6765"
}

// The correct numbers are memoized during fib(20) for n = 2-20.
fn check_fib_storage(fib: fn(Int) -> #(Int, Cache)) -> Nil {
  let #(value, cache) = fib(20)
  assert value == 6765 as "The 20th Fibonacci number is 6765"
  assert dict.size(dict.drop(cache, [0, 1])) == 19
    as "After computing fib(20), the returned cache should hold every Fibonacci number from the 2nd to the 20th: 19 entries"
  assert dict.get(cache, 2) == Ok(1)
    as "The returned cache should store the 2nd Fibonacci number, 1, under the key 2"
  assert dict.get(cache, 10) == Ok(55)
    as "The returned cache should store the 10th Fibonacci number, 55, under the key 10"
  assert dict.get(cache, 20) == Ok(6765)
    as "The returned cache should store the 20th Fibonacci number, 6765, under the key 20"
}

// fib(70) takes years unless every recursive call receives the cache so far.
fn check_fib_large(fib: fn(Int) -> #(Int, Cache)) -> Nil {
  assert fib(70).0 == 190_392_490_709_135
    as "The 70th Fibonacci number is 190392490709135"
}
