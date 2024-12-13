import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  parsed = parse(sample_data)
  assert len(parsed) == 4
  assert parsed[0] == {
    'A': (94, 34),
    'B': (22, 67),
    'prize': (8400, 5400)
  }

def test_solver(parsed_data):
  assert solver(parsed_data[0]) == [80, 40]
  assert solver(parsed_data[2]) == [38, 86]

def test_solver_no_solution(parsed_data):
  assert solver(parsed_data[1]) == None
  assert solver(parsed_data[3]) == None

def test_cost(parsed_data):
  assert cost([38, 86]) == 200

def test_part1(sample_data):
  breakpoint()
  assert part1(sample_data) == 480

# def test_part2(sample_data):
#   assert part2(sample_data) == 81
