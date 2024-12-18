import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
"""

@pytest.fixture
def parsed_data_a(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  registers, program = parse(sample_data)

  assert registers['A'] == 729
  assert registers['B'] == 0
  assert registers['C'] == 0

  assert program == [0, 1, 5, 4, 3, 0]

# Combo operands 0 through 3 represent literal values 0 through 3.
# Combo operand 4 represents the value of register A.
# Combo operand 5 represents the value of register B.
# Combo operand 6 represents the value of register C.
# Combo operand 7 is reserved and will not appear in valid programs.
@pytest.mark.parametrize("combo, expected", [
  (0, 0),
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 111),
  (5, 222),
  (6, 333),
  (7, -1),
])
def test_get_combo(combo, expected):
  registers = {'A': 111, 'B': 222, 'C': 333}
  assert get_combo(combo, registers) == expected

@pytest.mark.parametrize("initial_registers, program, expected_registers, expected_output", [
  # If register C contains 9, the program 2,6 would set register B to 1.
  ({'C': 9}, [2, 6], {'B': 1}, []),
  # If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
  ({'A': 10}, [5, 0, 5, 1, 5, 4], {}, [0, 1, 2]),
  # # If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
  ({'A': 2024}, [0, 1, 5, 4, 3, 0], {'A': 0}, [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]),
  # If register B contains 29, the program 1,7 would set register B to 26.
  ({'B': 29}, [1, 7], {'B': 26}, []),
  # If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
  ({'B': 2024, 'C': 43690}, [4, 0], {'B': 44354}, []),
  ({'A': 4}, [6, 1], {'B': 2}, []),
  ({'A': 4}, [7, 1], {'C': 2}, []),
])
def test_run_program(initial_registers, program, expected_registers, expected_output):
  start_registers = {**{'A': 0, 'B': 0, 'C': 0}, **initial_registers}
  registers, output = run_program(start_registers, program)

  if expected_registers:
    print(f"Expected Registers: {expected_registers}")
    for k, v in expected_registers.items():
      print(f"\t{k}: {v}")
      assert registers[k] == v

  if expected_output:
    assert output == expected_output

def test_part1(sample_data):
  assert part1(sample_data) == [4,6,3,5,6,3,5,2,1,0]

# def test_part2(sample_data_a):
#   assert part2(sample_data_a) == 45