//// Tests for `repeatedly_cube`.

import lab01.{repeatedly_cube}

pub fn repeatedly_cube_examples_test() {
  assert repeatedly_cube(2, 2) == 512 as "Cubing 2 twice: 2 -> 8 -> 512"
  assert repeatedly_cube(3, 2) == 134_217_728
    as "Cubing 2 three times: 2 -> 8 -> 512 -> 134217728"
  assert repeatedly_cube(1, 4) == 64 as "Cubing 4 once: 4 -> 64"
}

pub fn repeatedly_cube_no_cubes_test() {
  assert repeatedly_cube(0, 5) == 5 as "Cubing 5 zero times leaves it unchanged"
}

// 1 cubed any number of times is still 1, which is how many cubes can be
// checked without the result outgrowing the numbers Gleam can hold.
pub fn repeatedly_cube_many_times_test() {
  assert repeatedly_cube(100, 1) == 1
    as "Cubing 1 a hundred times: 1 -> 1 -> 1 -> ... -> 1"
}
