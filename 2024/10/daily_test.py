import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
"""

def test_parse(sample_data):
  grid = parse(sample_data)
  assert grid[0][0] == 8
  assert grid[7][7] == 2

def test_path_find(sample_data):
  grid = parse(sample_data)
  assert len(path_find(grid)) == 9
  # relies on trail heads being in reading order
  assert path_find(grid) == [5, 6, 5, 3, 1, 3, 5, 3, 5]

def test_path_score(sample_data):
  grid = parse(sample_data)
  assert len(path_score(grid)) == 9
  # relies on trail heads being in reading order
  assert path_score(grid) == [20, 24, 10, 4, 1, 4, 5, 8, 5]

def test_part1(sample_data):
  assert part1(sample_data) == 36

def test_part2(sample_data):
  assert part2(sample_data) == 81
