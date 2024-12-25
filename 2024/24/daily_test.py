import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  connections, values = parse(sample_data)

  assert values['x00'] == 1
  assert values['x01'] == 0
  assert values['x02'] == 1

  assert connections['mjb'] == ('ntg', 'XOR', 'fgs')
  assert connections['tnw'] == ('y02', 'OR', 'x01')
  assert connections['z05'] == ('kwq', 'OR', 'kpj')

def test_power_up(parsed_data):
  connections, values = parsed_data
  
  assert power_up('x00', connections, values)[0] == 1
  assert power_up('x01', connections, values)[0] == 0
  assert power_up('x02', connections, values)[0] == 1

  assert power_up('z00', connections, values)[0] == 0
  assert power_up('z01', connections, values)[0] == 0
  assert power_up('z02', connections, values)[0] == 0
  assert power_up('z03', connections, values)[0] == 1
  assert power_up('z04', connections, values)[0] == 0
  assert power_up('z05', connections, values)[0] == 1
  assert power_up('z06', connections, values)[0] == 1
  assert power_up('z07', connections, values)[0] == 1
  assert power_up('z08', connections, values)[0] == 1
  assert power_up('z09', connections, values)[0] == 1
  assert power_up('z10', connections, values)[0] == 1
  assert power_up('z11', connections, values)[0] == 0
  assert power_up('z12', connections, values)[0] == 0

def test_part1(sample_data):
  assert part1(sample_data) == 2024

# def test_part2(sample_data):
#   assert part2(sample_data) == "co,de,ka,ta"