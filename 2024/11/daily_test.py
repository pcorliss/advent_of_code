import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
125 17
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  parsed = parse(sample_data)
  assert parsed == [125, 17]

@pytest.mark.parametrize("times, expected", [
  (1, [253000,1,7]),
  (2, [253,0,2024,14168]),
  (3, [512072,1,20,24,28676032]),
  (4, [512,72,2024,2,0,2,4,2867,6032]),
  (5, [1036288,7,2,20,24,4048,1,4048,8096,28,67,60,32]),
  (6, [2097446912,14168,4048,2,0,2,4,40,48,2024,40,48,80,96,2,8,6,7,6,0,3,2]),
])
def test_blink(parsed_data, times, expected):
  d = parsed_data
  for i in range(times):
    d = blink(d)

  assert d == expected

def test_part1(sample_data):
  assert part1(sample_data) == 55312

# def test_part2(sample_data):
#   assert part2(sample_data) == 81
