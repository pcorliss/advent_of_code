import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
029A
980A
179A
456A
379A
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  codes = parse(sample_data)
  assert len(codes) == 5
  assert codes[0] == ['0', '2', '9', 'A']
  pass

# +---+---+---+       +---+---+
# | 7 | 8 | 9 |       | ^ | A |
# +---+---+---+   +---+---+---+
# | 4 | 5 | 6 |   | < | v | > |
# +---+---+---+   +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+  

@pytest.mark.parametrize("code, expected", [
  (['0','2','9','A'], "<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A"),
  (['9','8','0','A'], "<v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A"),
  (['1','7','9','A'], "<v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A"),
  (['4','5','6','A'], "<v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A"),
  (['3','7','9','A'], "<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A"),
])
def test_code_directions(code, expected):
  assert len(code_directions(code)) == len(expected)

# def test_part1(sample_data):
#   assert part1(sample_data) == 4

# def test_part2(sample_data):
#   assert part2(sample_data) == 285