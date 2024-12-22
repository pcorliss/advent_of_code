import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
1
10
100
2024
"""

@pytest.fixture
def sample_data_2():
  return """
1
2
3
2024
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  codes = parse(sample_data)
  assert len(codes) == 4
  assert codes == [1, 10, 100, 2024]


@pytest.mark.parametrize("secret_number, generation, expected", [
  (123, 1, 15887950),
  (123, 2, 16495136),
  (123, 3, 527345),
  (123, 4, 704524),
  (123, 5, 1553684),
  (123, 6, 12683156),
  (123, 7, 11100544),
  (123, 8, 12249484),
  (123, 9, 7753432),
  (123, 10, 5908254),
  (1, 2000, 8685429),
  (10, 2000, 4700978),
  (100, 2000, 15273692),
  (2024, 2000, 8667524),
])
def test_gen_code(secret_number, generation, expected):
  assert gen_code(secret_number, generation) == expected

def test_part1(sample_data):
  assert part1(sample_data) == 37327623

def test_part2(sample_data_2):
  sequence, bananas = part2(sample_data_2)
  assert sequence == (-2,1,-1,3)
  assert bananas == 23