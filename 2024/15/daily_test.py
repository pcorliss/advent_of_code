import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
"""

@pytest.fixture
def small_sample():
  return """
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

@pytest.fixture
def small_parsed_data(small_sample):
  return parse(small_sample)

def test_parse(sample_data):
  grid, moves, start = parse(sample_data)
  assert len(grid) == 10
  assert len(grid[0]) == 10
  assert grid[0][0] == '#'
  assert grid[9][9] == '#'
  assert grid[4][4] == '.' # start pos converted to .
  assert grid[1][3] == 'O'

  assert len(moves) == 700
  assert moves[0] == '<'
  assert moves[-1] == '^'

  assert start == (4,4)


########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

def test_move_just_moves(small_parsed_data):
  grid, _, start = small_parsed_data
  moves = ['v','>','v','v','<','<','^']
  new_grid, new_pos = move(grid, start, moves)

  assert new_grid == grid
  assert new_pos == (1,4)

def test_move_bounces_walls(small_parsed_data):
  grid, _, start = small_parsed_data
  moves = ['v','v','v','v']
  new_grid, new_pos = move(grid, start, moves)

  assert new_grid == grid
  assert new_pos == (2, 3)

def test_move_moves_boxes(small_parsed_data):
  grid, moves, start = small_parsed_data
  new_grid, new_pos = move(grid, start, moves)
  
  expected_state = """
########
#....OO#
##.....#
#.....O#
#.#O@..#
#...O..#
#...O..#
########
"""

  expected_grid, _, expected_pos  = parse(expected_state)

  assert new_grid == expected_grid
  assert new_pos == expected_pos

def test_move_large_example(parsed_data):
  grid, moves, start = parsed_data
  new_grid, new_pos = move(grid, start, moves)
  
  expected_state = """
##########
#.O.O.OOO#
#........#
#OO......#
#OO@.....#
#O#.....O#
#O.....OO#
#O.....OO#
#OO....OO#
##########
"""

  expected_grid, _, expected_pos  = parse(expected_state)

  assert new_grid == expected_grid
  assert new_pos == expected_pos

def test_gps():
  assert gps(0,0) == 0
  assert gps(0,1) == 100
  assert gps(1,1) == 101
  assert gps(2,2) == 202

def test_part1(small_sample_data):
  assert part1(small_sample_data) == 2028

def test_part1(sample_data):
  assert part1(sample_data) == 10092

# def test_part2(sample_data):
#   assert part2(sample_data) == 875318608908
