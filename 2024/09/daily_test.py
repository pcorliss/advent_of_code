import pytest
from daily import *

#fixture
@pytest.fixture
def sample_data():
  return """
2333133121414131402
"""

@pytest.fixture
def rendered_expected():
  return "00...111...2...333.44.5555.6666.777.888899"

@pytest.fixture
def packed_expected():
  return "0099811188827773336446555566"

def render(data):
  out = ""
  for i in range(len(data)):
    d = data[i]
    if d == None:
      out += "."
    else:
      out += str(d)

  return out

def test_parse(sample_data, rendered_expected):
  parsed_data = parse(sample_data)
  assert render(parsed_data) == rendered_expected

def test_repack(sample_data, packed_expected):
  parsed_data = parse(sample_data)
  repacked_data = repack(parsed_data)

  assert render(repacked_data) == packed_expected

def test_checksum(sample_data):
  parsed_data = parse(sample_data)
  repacked_data = repack(parsed_data)

  assert checksum(repacked_data) == 1928

def test_part1(sample_data):
  assert part1(sample_data) == 1928

# def test_part2(sample_data):
#   assert part2(sample_data) == 34