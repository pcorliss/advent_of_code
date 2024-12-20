import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  grid, s, e = parse(sample_data)
  
  assert len(grid) == 15
  assert len(grid[0]) == 15

  assert s == (1, 3)
  assert e == (5, 7)

  assert grid[3][1] == '.'
  assert grid[7][5] == '.'


def test_fill_path(parsed_data):
  grid, s, e = parsed_data
  steps = fill_path(grid, s, e)

  assert steps[s] == 0
  assert steps[e] == 84

def test_cheat_options(parsed_data):
  grid, s, e = parsed_data
  steps = fill_path(grid, s, e)
  options = cheat_options(steps)

  assert len(options) == 44
  assert 20 in options
  assert 36 in options
  assert 38 in options
  assert 40 in options
  assert 64 in options


def test_part1(sample_data):
  assert part1(sample_data, 36) == 4

def test_part2(sample_data):
  assert part2(sample_data, 50) == 285