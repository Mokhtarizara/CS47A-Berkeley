//// Tests for `compose` and `next_hailstone`.

import lab01.{compose, next_hailstone}

fn add_one(x: Int) -> Int {
  x + 1
}

fn double(x: Int) -> Int {
  x * 2
}

pub fn compose_examples_test() {
  assert compose(add_one, double)(3) == 7
    as "compose(add_one, double)(3) is add_one(double(3)) = 2 * 3 + 1 = 7, not double(add_one(3)) = 8"
  assert compose(double, add_one)(3) == 8
    as "compose(double, add_one)(3) is double(add_one(3)) = (3 + 1) * 2 = 8"
}

pub fn compose_anonymous_functions_test() {
  assert compose(fn(x) { x * x }, fn(x) { x - 1 })(5) == 16
    as "Subtracting 1 from 5 and then squaring gives 4 * 4 = 16"
  assert compose(add_one, add_one)(0) == 2 as "Adding 1 to 0 twice gives 2"
}

pub fn compose_twice_test() {
  let add_two = compose(add_one, add_one)
  assert compose(add_two, add_two)(10) == 14
    as "A function that compose returns can be composed again: adding 2 to 10 twice gives 14"
  assert compose(double, compose(double, double))(1) == 8
    as "Doubling 1 three times gives 8"
}

pub fn next_hailstone_examples_test() {
  // The hailstone sequence starting at 3: 3, 10, 5, 16, 8, 4, 2, 1
  assert next_hailstone(3) == 10
    as "3 is odd, so the next hailstone number is 3 * 3 + 1 = 10"
  assert next_hailstone(10) == 5
    as "10 is even, so the next hailstone number is 10 / 2 = 5"
  assert next_hailstone(5) == 16
    as "5 is odd, so the next hailstone number is 3 * 5 + 1 = 16"
  assert next_hailstone(16) == 8
    as "16 is even, so the next hailstone number is 16 / 2 = 8"
  assert next_hailstone(8) == 4
    as "8 is even, so the next hailstone number is 8 / 2 = 4"
  assert next_hailstone(4) == 2
    as "4 is even, so the next hailstone number is 4 / 2 = 2"
  assert next_hailstone(2) == 1
    as "2 is even, so the next hailstone number is 2 / 2 = 1"
}
