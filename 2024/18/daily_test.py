import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  fb_map, grid= parse(sample_data)
  
  assert len(fb_map) == 25
  assert fb_map[(5,4)] == 0
  assert fb_map[(2,0)] == 24

def test_pathfinder(parsed_data):
  fb_map, grid = parsed_data
  render(grid, 12)
  assert pathfinder(fb_map, 12, (0,0), (6,6)) == 22

def test_time_codes(parsed_data):
  fb_map, _ = parsed_data
  assert find_blocker(fb_map, 12, (0,0), (6,6)) == (6,1)

def test_part1(sample_data):
  assert part1(sample_data, 12, (0,0), (6,6)) == 22

def test_part2(sample_data):
  assert part2(sample_data, 12, (0,0), (6,6)) == (6,1)