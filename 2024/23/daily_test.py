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

def test_largest_group(parsed_data):
  triplets = find_triplets(parsed_data)
  largest = largest_group(parsed_data, triplets)
  assert largest == set(['co', 'de', 'ka', 'ta'])

def test_valid_cluster(parsed_data):
  assert valid_cluster(parsed_data, set(['co', 'de', 'ka', 'ta']))
  assert not valid_cluster(parsed_data, set(['co', 'de', 'ka', 'ta', 'tc']))

def test_prune_intersection(parsed_data):
  assert prune_intersection(parsed_data, ('co', 'ka', 'ta'), set(['co', 'de', 'ka', 'ta'])) == ('co', 'de', 'ka', 'ta')

def test_part1(sample_data):
  assert part1(sample_data) == 7

def test_part2(sample_data):
  assert part2(sample_data) == "co,de,ka,ta"