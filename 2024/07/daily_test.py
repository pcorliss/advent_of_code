import pytest
from daily import *

@pytest.fixture
def sample_data():
    return """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""

def test_parse(sample_data):
    parsed_data = parse(sample_data)

    assert len(parsed_data) == 9
    assert parsed_data[192] == [17, 8, 14]

def test_add_symbols_one_pos(sample_data):
    symbolized_data = add_symbols(190, [10, 19], ['+', '*'])

    assert symbolized_data == [10, '*', 19]

# def test_add_symbols_two_pos(sample_data):
#     symbolized_data = add_symbols(3267, [81,40,27], ['+', '*'])

#     # Symbols can be swapped so test may be unstable
#     assert symbolized_data == [81, '*', 40, '+', 27]

def test_add_symbols_left_to_right(sample_data):
    symbolized_data = add_symbols(292, [11,6,16,20], ['+', '*'])

    # Symbols can be swapped so test may be unstable
    assert symbolized_data == [11, '+', 6, '*', 16, '+', 20]

def test_add_symbols_unsolvable(sample_data):
    symbolized_data = add_symbols(83, [17,5], ['+', '*'])

    assert symbolized_data is None

# 156: 15 6 can be made true through a single concatenation: 15 || 6 = 156.
# 7290: 6 8 6 15 can be made true using 6 * 8 || 6 * 15.
# 192: 17 8 14 can be made true using 17 || 8 + 14.

def test_add_symbols_concatenation(sample_data):
    symbolized_data = add_symbols(156, [15,6], ['+', '*', '||'])

    assert symbolized_data == [15, '||', 6]

    symbolized_data = add_symbols(7290, [6,8,6,15], ['+', '*', '||'])

    assert symbolized_data == [6, '*', 8, '||', 6, '*', 15]

    symbolized_data = add_symbols(192, [17,8,14], ['+', '*', '||'])

    assert symbolized_data == [17, '||', 8, '+', 14]

def test_part1(sample_data):
    assert part1(sample_data) == 3749

def test_part2(sample_data):
    assert part2(sample_data) == 11387