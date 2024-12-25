import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  locks, keys = parse(sample_data)

  assert len(locks) == 2
  assert len(keys) == 3

def test_pin_heights(parsed_data):
  locks, keys = parsed_data

  assert pin_heights(locks[0]) == [0,5,3,4,3]
  assert pin_heights(locks[1]) == [1,2,0,5,3]
  assert pin_heights(keys[0]) == [5,0,2,1,3]
  assert pin_heights(keys[1]) == [4,3,4,0,2]
  assert pin_heights(keys[2]) == [3,0,2,0,1]

def test_overlap(parsed_data):
  locks, keys = parsed_data

  assert overlap(pin_heights(locks[0]), pin_heights(keys[0]))
  assert overlap(pin_heights(locks[0]), pin_heights(keys[1]))
  assert overlap(pin_heights(locks[1]), pin_heights(keys[0]))

  assert not overlap(pin_heights(locks[0]), pin_heights(keys[2]))
  assert not overlap(pin_heights(locks[1]), pin_heights(keys[1]))
  assert not overlap(pin_heights(locks[1]), pin_heights(keys[2]))

def test_part1(sample_data):
  assert part1(sample_data) == 3

# def test_part2(sample_data):
#   assert part2(sample_data) == 81