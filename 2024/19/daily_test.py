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


# brwrr can be made with a br towel, then a wr towel, and then finally an r towel.
# bggr can be made with a b towel, two g towels, and then an r towel.
# gbbr can be made with a gb towel and then a br towel.
# rrbgbr can be made with r, rb, g, and br.
# ubwu is impossible.
# bwurrg can be made with bwu, r, r, and g.
# brgr can be made with br, g, and r.
# bbrgwb is impossible.
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

def test_part1(sample_data):
  assert part1(sample_data) == 6

# def test_part2(sample_data):
#   assert part2(sample_data, 12, (0,0), (6,6)) == (6,1)