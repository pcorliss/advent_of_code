import pytest
from daily import *

@pytest.fixture
def sample_data():
  return """
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
"""

@pytest.fixture
def parsed_data(sample_data):
  return parse(sample_data)

def test_parse(sample_data):
  tokens, words, prefix_trie = parse(sample_data)

  assert len(tokens) == 8
  assert tokens[7] == 'br'
  assert len(words) == 8
  assert words[7] == "bbrgwb"

  assert len(prefix_trie) == 8
  assert prefix_trie.has_key('bwu')
  assert not prefix_trie.has_key('iwu')

@pytest.mark.parametrize("word, expected", [
  ('brwrr', True),
  ('bggr', True),
  ('gbbr', True),
  ('rrbgbr', True),
  ('ubwu', False),
  ('bwurrg', True),
  ('brgr', True),
  ('bbrgwb', False),
])
def test_string_contains(parsed_data, word, expected):
  _, _, trie = parsed_data
  assert string_contains(word, trie) == expected

@pytest.mark.parametrize("word, expected", [
  ('brwrr', [['b', 'r', 'wr', 'r'], ['br', 'wr', 'r']]),
  ('bggr', [['b', 'g', 'g', 'r']]),
  ('gbbr', [
    ['g', 'b', 'b', 'r'],
    ['g', 'b', 'br'],
    ['gb', 'b', 'r'],
    ['gb', 'br'],
  ]),
  ('rrbgbr', [
    ['r', 'r', 'b', 'g', 'b', 'r'],
    ['r', 'r', 'b', 'g', 'br'],
    ['r', 'r', 'b', 'gb', 'r'],
    ['r', 'rb', 'g', 'b', 'r'],
    ['r', 'rb', 'g', 'br'],
    ['r', 'rb', 'gb', 'r'],
  ]),
  ('ubwu', []),
  ('bwurrg', [['bwu', 'r', 'r', 'g']]),
  ('brgr', [['b', 'r', 'g', 'r'], ['br', 'g', 'r']]),
  ('bbrgwb', []),
])
def test_all_combos(parsed_data, word, expected):
  _, _, trie = parsed_data
  assert sorted(all_combos(word, trie)) == sorted(expected)

@pytest.mark.parametrize("word, expected", [
  ('brwrr', 2),
  ('bggr', 1),
  ('gbbr', 4),
  ('rrbgbr', 6),
  ('ubwu', 0),
  ('bwurrg', 1),
  ('brgr', 2),
  ('bbrgwb', 0),
])
def test_string_sums(parsed_data, word, expected):
  _, _, trie = parsed_data
  assert string_sums(word, trie) == expected

def test_part1(sample_data):
  assert part1(sample_data) == 6

def test_part2(sample_data):
  assert part2(sample_data) == 16