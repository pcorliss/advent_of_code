import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  graph = parse(sample_data)

  assert 'tc' in graph['kh']
  assert 'kh' in graph['tc']

def test_triplets(parsed_data):
  triplets = find_triplets(parsed_data)
  assert len(triplets) == 12

def test_part1(sample_data):
  assert part1(sample_data) == 7

# def test_part2(sample_data_2):
#   sequence, bananas = part2(sample_data_2)
#   assert sequence == (-2,1,-1,3)
#   assert bananas == 23