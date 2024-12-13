import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
"""

@pytest.fixture
def e_grid():
  s = """
EEEEE
EXXXX
EEEEE
EXXXX
EEEEE
"""
  return(parse(s))

@pytest.fixture
def ab_grid():
  s = """
AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA
"""
  return(parse(s))

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  grid = parse(sample_data)
  assert grid[0][0] == 'R'
  assert grid[9][9] == 'E'

def test_blocks(parsed_data):
  pos_set = blocks(parsed_data, 0, 0)

  assert len(pos_set) == 12
  assert (0,0) in pos_set
  assert (4,2) in pos_set
  assert (2,3) in pos_set

def test_perimeter(parsed_data):
  b = blocks(parsed_data, 0, 0)
  assert perimeter(parsed_data, b) == 18

def test_sides_e_grid(e_grid):
  b = blocks(e_grid, 0, 0)
  assert sides(e_grid, b) == 12

def test_sides_ab_grid(ab_grid):
  b = blocks(ab_grid, 0, 0)
  assert sides(ab_grid, b) == 12

def test_corners_e_grid(e_grid):
  b = blocks(e_grid, 0, 0)
  assert corners(b) == 12

def test_corners_ab_grid(ab_grid):
  b = blocks(ab_grid, 0, 0)
  assert corners(b) == 12

def test_part1(sample_data):
  assert part1(sample_data) == 1930

def test_part2(sample_data):
  assert part2(sample_data) == 1206
