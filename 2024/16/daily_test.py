import pytest
from daily import *

@pytest.fixture
def sample_data_a():
  return """
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"""

@pytest.fixture
def sample_data_b():
  return """
#################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################
"""

@pytest.fixture
def parsed_data_a(sample_data_a):
  return parse(sample_data_a)

@pytest.fixture
def parsed_data_b(sample_data_b):
  return parse(sample_data_b)

def test_parse(sample_data_a):
  grid, graph, s, dir, e = parse(sample_data_a)
  assert len(grid) == 15
  assert len(grid[0]) == 15
  assert grid[0][0] == '#'
  # Repalce S and E with .
  assert grid[13][1] == '.'

  # assert len(graph) == 15
  assert s == (1,13)
  assert e == (13,1)
  assert dir == (1,0)

  # print(f"Graph: {graph}")
  assert len(graph) == 64

def test_intersection(parsed_data_a):
  grid, _, _, _, _ = parsed_data_a

  # Wall
  assert intersection(grid, 0, 0) == False
  # Hallway
  assert intersection(grid, 5, 1) == False
  # Hallway with Turn
  assert intersection(grid, 1, 1) == False
  # Small Hallway
  assert intersection(grid, 3, 2) == False
  # 3-way Intersection
  assert intersection(grid, 1, 3) == True
  # 4-way Intersection
  assert intersection(grid, 3, 7) == True

def test_build_intersections(parsed_data_a):
  grid, _, _, _, _ = parsed_data_a
  i = build_intersections(grid)

  # Did not validate this length
  assert len(i) == 14

  assert (1,3) in i
  assert (3,7) in i

  assert (0, 0) not in i
  assert (5, 1) not in i
  assert (1, 1) not in i
  assert (3, 2) not in i

# All turns are right turns
def test_turn():
  assert turn((0,1), 1) == (-1,0)
  assert turn((0,1), 2) == (0,-1)
  assert turn((0,1), 3) == (1,0)
  assert turn((0,1), 4) == (0,1)

def test_find_end_path(parsed_data_a):
  grid, graph, s, dir, e = parsed_data_a
  score, path_tiles = find_end_path(grid, graph, s, dir, e)
  assert score == 7036
  assert len(path_tiles) == 45

def test_find_end_path(parsed_data_b):
  grid, graph, s, dir, e = parsed_data_b
  score, path_tiles = find_end_path(grid, graph, s, dir, e)
  assert score == 11048
  assert len(path_tiles) == 64

def test_part1(sample_data_a):
  assert part1(sample_data_a) == 7036

def test_part2(sample_data_a):
  assert part2(sample_data_a) == 45