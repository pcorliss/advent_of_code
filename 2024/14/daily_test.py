import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
"""

@pytest.fixture
def sample_dims():
  return (11,7)

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  parsed = parse(sample_data)
  assert len(parsed) == 12
  assert parsed[0] == ([0,4],[3,-3])
  assert parsed[11] == ([9,5], [-3,-3])

def test_tick_regular_movement(parsed_data, sample_dims):
  ticked = tick(parsed_data, sample_dims)
  assert len(ticked) == 12
  # Handles regular movement
  # p=0,4 v=3,-3
  assert ticked[0] == ([3,1],[3,-3])
  # p=9,5 v=-3,-3
  assert ticked[11] == ([6,2], [-3,-3])

def test_tick_bounce_wall_movement(parsed_data, sample_dims):
  ticked = tick(parsed_data, sample_dims)
  assert len(ticked) == 12
  # p=2,0 v=2,-1
  assert ticked[3] == ([4,6],[2,-1])

def test_tick_takes_steps_argument(parsed_data, sample_dims):
  ticked = tick(parsed_data, sample_dims, 2)
  assert len(ticked) == 12
  # p=0,4 v=3,-3
  assert ticked[0] == ([6,5],[3,-3])
  # p=9,5 v=-3,-3
  assert ticked[11] == ([3,6], [-3,-3])

def test_count_quads(parsed_data, sample_dims):
  robots = tick(parsed_data, sample_dims, 100)
  count = count_quads(robots, sample_dims)
  assert count == [1,3,4,1]

def test_part1(sample_data, sample_dims):
  assert part1(sample_data, sample_dims) == 12

# def test_part2(sample_data):
#   assert part2(sample_data) == 875318608908
