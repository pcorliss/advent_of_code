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
  (['3','7','9','A'], "A"*64),
  # (['7','3','9','A'], "A"*78),
])
def test_direction_options(code, expected):
  assert len(code_directions(code)) == len(expected)

@pytest.mark.parametrize("start, end, type, expected", [
  ((0,0), (2,3), DIGIT, [['>', '>', 'v', 'v', 'v']]),
  ((2,3), (0,0), DIGIT, [['^', '^', '^', '<', '<']]),
  ((0,0), (2,2), DIGIT, [['>', '>', 'v', 'v'], ['v', 'v', '>', '>']]),
  ((2,2), (0,0), DIGIT, [['<', '<', '^', '^'], ['^', '^', '<', '<']]),
  ((0,1), (1,0), DPAD,  [['>', '^']]),
  ((1,0), (0,1), DPAD,  [['v', '<']]),
  ((2,0), (1,1), DPAD,  [['<', 'v'], ['v', '<']]),
  ((1,1), (2,0), DPAD,  [['>', '^'], ['^', '>']]),
])
def test_code_directions(start, end, type, expected):
  print(f"expected: {sorted(expected)}")
  print(f"code_dir: {sorted(direction_options(start, end, type))}")
  assert direction_options(start, end, type) == expected

# Line 3: 456A
# v<<A^>>AAv<A<A^>>AAvAA^<A>Av<A^>A<A>Av<A^>A<A>Av<<A>A^>AAvA^<A>A [human]
#    <   AA  v <   AA >>  ^ A  v  A ^ A  v  A ^ A   < v  AA >  ^ A [robot 3]
#        ^^        <<       A     >   A     >   A        vv      A [robot 2]
#                           4         5         6                A [keypad robot]
@pytest.mark.parametrize("directions, depth, expected", [
  (['4','5','6','A'], 0, 4),
  (['4','5','6','A'], 1, 12),
  (['4','5','6','A'], 2, 26),
  (['4','5','6','A'], 3, 64),
  (['3','7','9','A'], 3, 64),
  (['7','3','9','A'], 3, 78),
  (['0','2','9','A'], 3, len("<vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A")),
  (['9','8','0','A'], 3, len("<v<A>>^AAAvA^A<vA<AA>>^AvAA<^A>A<v<A>A>^AAAvA<^A>A<vA>^A<A>A")),
  (['1','7','9','A'], 3, len("<v<A>>^A<vA<A>>^AAvAA<^A>A<v<A>>^AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A")),
  (['4','5','6','A'], 3, len("<v<A>>^AA<vA<A>>^AAvAA<^A>A<vA>^A<A>A<vA>^A<A>A<v<A>A>^AAvA<^A>A")),
  (['3','7','9','A'], 3, 64),
  (['7','3','9','A'], 3, 78),
])
def test_direction_length(directions, depth, expected):
  assert direction_length(directions, depth) == expected

def test_complexity():
  code = ['0','2','9','A']
  assert complexity(code, 68) == 68 * 29

def test_part1(sample_data):
  assert part1(sample_data) == 126384

def test_part2(sample_data):
  assert part2(sample_data) == 154115708116294