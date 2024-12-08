import pytest
from daily import *

#fixture
@pytest.fixture
def sample_data():
  return """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""

def test_parse(sample_data):
  parsed_data = parse(sample_data)
  assert len(parsed_data) == 12
  assert len(parsed_data[0]) == 12
  assert parsed_data[0][0] == '.' 
  assert parsed_data[1][8] == '0'

def test_antinodes(sample_data):
  parsed_data = parse(sample_data)
  anti = antinodes(parsed_data)

  assert len(anti) == 14
  assert (0,7) in anti
  assert (11,0) in anti

def test_part1(sample_data):
  assert part1(sample_data) == 14

def test_repeating_antinodes(sample_data):
  parsed_data = parse(sample_data)
  anti = repeating_antinodes(parsed_data)

  assert len(anti) == 34

def test_part2(sample_data):
  assert part2(sample_data) == 34