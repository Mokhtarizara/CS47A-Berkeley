import compose_test
import grader.{check, question}
import memo_fib_test
import repeatedly_cube_test

pub fn main() -> Nil {
  grader.main([
    question("repeatedly_cube", 0, [
      check(
        "repeatedly_cube_examples_test",
        repeatedly_cube_test.repeatedly_cube_examples_test,
      ),
      check(
        "repeatedly_cube_no_cubes_test",
        repeatedly_cube_test.repeatedly_cube_no_cubes_test,
      ),
      check(
        "repeatedly_cube_many_times_test",
        repeatedly_cube_test.repeatedly_cube_many_times_test,
      ),
    ]),
    question("compose", 0, [
      check("compose_examples_test", compose_test.compose_examples_test),
      check(
        "compose_anonymous_functions_test",
        compose_test.compose_anonymous_functions_test,
      ),
      check("compose_twice_test", compose_test.compose_twice_test),
    ]),
    question("next_hailstone", 0, [
      check(
        "next_hailstone_examples_test",
        compose_test.next_hailstone_examples_test,
      ),
    ]),
    question("fib_memoized", 0, [
      check("fib_memoized_test", memo_fib_test.fib_memoized_test),
    ]),
    question("fib_passing", 0, [
      check("fib_passing_test", memo_fib_test.fib_passing_test),
    ]),
  ])
}
