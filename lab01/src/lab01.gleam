//// Lab 1: Gleam Functions.

/// gleam test -- for whole testing 
/// gealm test -- repeatedly_cube -> just for this question.
import gleam/dict.{type Dict}

//g1
/// Cube `x` a total of `n` times, where `n` is a nonnegative integer.
pub fn repeatedly_cube(n: Int, x: Int) -> Int {
  // YOUR CODE HERE (replace the code below)
  // my solution base case: first we need to handle the base case if is no operation like zero -> return the x
  // we should also handle the each n time operation like how many cubes if two and we did one operation the next we need to n - 1 so we handle next operation.

  case n {
    0 -> x
    _ -> repeatedly_cube(n - 1, x * x * x)
    // function call each time and reduce the operation each time cause it takes n and x as argument
  }
}

//q2
/// A function of `x` that returns the result of calling `f` on `g` of `x`.
pub fn compose(f: fn(Int) -> Int, g: fn(Int) -> Int) -> fn(Int) -> Int {
  // YOUR CODE HERE (replace the code below)
  // my solution: the compose is mean fist inner and then outer; it takes two func f,g. 
  //return a new function f() -> call the function ; fn() -> creating new function 
  // compose rule is (f,g)(x) = f(g(x)) x gets to g first 
  fn(x) { f(g(x)) }
}

// we have four option to choose
fn odd(n: Int) -> Bool {
  n % 2 == 1
}

fn triple(n: Int) -> Int {
  3 * n
}

fn half(n: Int) -> Int {
  n / 2
}

fn increment(n: Int) -> Int {
  n + 1
}

// the choose condition to follow
fn choose(
  condition: fn(Int) -> Bool,
  if_true: fn(Int) -> Int,
  if_false: fn(Int) -> Int,
) -> fn(Int) -> Int {
  fn(x) {
    case condition(x) {
      True -> if_true(x)
      False -> if_false(x)
    }
  }
}

/// The number after `n` in a hailstone sequence.
pub fn next_hailstone(n: Int) -> Int {
  // YOUR CODE HERE (replace the code below)
  // my solution: we use compose to combine the function the odd ->  multi and add 1
  let odd_operation = compose(increment, triple)
  let operation = choose(odd, odd_operation, half)
  operation(n)
}

//q3 - part 1
/// The nth Fibonacci number.
/// explain to my self: 0 or 1 return n - other: return two previous and sum of them.
pub fn fib(n: Int) -> Int {
  case n {
    0 | 1 -> n
    _ -> fib(n - 2) + fib(n - 1)
  }
}

/// explain to my self: cache is like value that have been saved and its dict key, value both integer;
/// and we need two function only insert: return the results and get 
/// A dictionary of each Fibonacci number found so far, keyed by its index.
pub type Cache =
  Dict(Int, Int)

/// The nth Fibonacci number, found using the cache, along with a cache that also
/// contains every Fibonacci number found along the way.
/// 
/// 1. input: (n, cache)
/// 2. output: 
pub fn fib_memoized(n: Int, cache: Cache) -> #(Int, Cache) {
  case n {
    0 | 1 -> #(n, cache)
    _ ->
      // YOUR CODE HERE (replace the code below)
      case dict.get(cache, n) {
        Ok(value) -> #(value, cache)
        Error(Nil) -> {
          let #(a, cache) = fib_memoized(n - 2, cache)
          // getting fib two prev
          let #(b, cache) = fib_memoized(n - 1, cache)
          // getting fib one prev
          let fib_sum = a + b
          let new_cache = dict.insert(cache, n, fib_sum)
          // adding both 
          #(fib_sum, new_cache)
          // writing answer and new updated cache
        }
      }
  }
}

///q3 - part2
/// A step takes the cache so far and produces a value along with the next cache.
type Step(a) =
  fn(Cache) -> #(a, Cache)

/// A step that just produces value. The cache is unchanged.
fn done(value: a) -> Step(a) {
  fn(cache) { #(value, cache) }
}

/// A step that runs the step first, then runs the step that next returns when
/// called on the value that first produced. The cache that results from first is
/// passed to that step, so a sequence of steps never has to mention the cache.
fn then(first: Step(a), next: fn(a) -> Step(b)) -> Step(b) {
  fn(cache) {
    let #(value, cache) = first(cache)
    next(value)(cache)
  }
}

/// A step that produces Ok(value) if value is stored in the cache for n, or
/// Error(Nil) if nothing is stored for n. The cache is unchanged.
fn lookup(n: Int) -> Step(Result(Int, Nil)) {
  fn(cache) { #(dict.get(cache, n), cache) }
}

/// A step that stores value in the cache for n, then produces value.
fn store(n: Int, value: Int) -> Step(Int) {
  fn(cache) { #(value, dict.insert(cache, n, value)) }
}

/// A step that produces the value stored in the cache for n. If nothing is
/// stored for n yet, store what compute returns (and return that value).
/// 
/// my explanation to my self: this part we returning the result by finding out if value there or not?
fn memoized(n: Int, compute: fn() -> Step(Int)) -> Step(Int) {
  then(lookup(n), fn(found) {
    case found {
      Ok(value) -> done(value)
      Error(Nil) -> then(compute(), fn(value) { store(n, value) })
    }
  })
}

/// A step that produces the nth Fibonacci number. The cache is never mentioned:
/// memoized looks up and stores values, and then passes the cache along.
pub fn fib_passing(n: Int) -> Step(Int) {
  case n {
    0 | 1 -> done(n)
    _ ->
      memoized(n, fn() {
        // YOUR CODE HERE (replace the code below)
        // using then and done helper function 
        then(fib_passing(n - 2), fn(a) {
          then(fib_passing(n - 1), fn(b) { done(a + b) })
        })
      })
  }
}

pub fn main() {
  echo "Try calling your functions here, then run this code with gleam run"
}
