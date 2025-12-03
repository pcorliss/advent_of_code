defmodule Day02Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day02.input(temp_file)
    assert length(result) == 11
    assert List.first(result) == {11, 22}
    assert List.last(result) == {2_121_212_118, 2_121_212_124}
  end

  # Returns the stringified and integer half of an integer
  test "split_integer" do
    assert Day02.split_integer(11) == {"1", 1}
    assert Day02.split_integer(95) == {"9", 9}
    assert Day02.split_integer(998) == {"9", 9}
    assert Day02.split_integer(446_443) == {"446", 446}
    assert Day02.split_integer(1_698_522) == {"169", 169}
    assert Day02.split_integer(1) == {"1", 1}
  end

  test "increment_until" do
    # Matches
    assert Day02.increment_until(1, 11, 11) == 11
    assert Day02.increment_until(9, 95, 115) == 99
    assert Day02.increment_until(446, 446_443, 446_449) == 446_446

    # Increments
    assert Day02.increment_until(1, 12, 22) == 22
    assert Day02.increment_until(9, 998, 1012) == 1010

    # No match
    assert Day02.increment_until(169, 1_698_522, 1_698_528) == nil
  end

  test "collect matches" do
    assert Day02.collect_matches({11, 33}) == [11, 22, 33]
    assert Day02.collect_matches({1_188_511_880, 1_188_511_890}) == [1_188_511_885]
    # 998-1012 has one invalid ID, 1010.
    assert Day02.collect_matches({998, 1012}) == [1010]

    # No Matches
    assert Day02.collect_matches({12, 21}) == []
  end

  test "part1", %{temp_file: temp_file} do
    assert Day02.part1(temp_file) == 1_227_775_554
  end

  test "repeating_pattern" do
    assert Day02.repeating_pattern(1) == false
    assert Day02.repeating_pattern(2) == false

    assert Day02.repeating_pattern(11) == true
    assert Day02.repeating_pattern(12) == false

    assert Day02.repeating_pattern(111) == true
    assert Day02.repeating_pattern(121) == false

    assert Day02.repeating_pattern(1111) == true
    assert Day02.repeating_pattern(1212) == true
    assert Day02.repeating_pattern(1113) == false
    assert Day02.repeating_pattern(1213) == false

    assert Day02.repeating_pattern(11111) == true
    assert Day02.repeating_pattern(12121) == false
    assert Day02.repeating_pattern(12312) == false

    assert Day02.repeating_pattern(111_111) == true
    assert Day02.repeating_pattern(121_212) == true
    assert Day02.repeating_pattern(123_123) == true
    assert Day02.repeating_pattern(123_124) == false
  end

  test "collecting_matches_part_2" do
    assert Day02.collect_matches_part_2({11, 22}) == [11, 22]
    assert Day02.collect_matches_part_2({95, 115}) == [99, 111]
    assert Day02.collect_matches_part_2({998, 1012}) == [999, 1010]
    assert Day02.collect_matches_part_2({1_188_511_880, 1_188_511_890}) == [1_188_511_885]
    assert Day02.collect_matches_part_2({222_220, 222_224}) == [222_222]
    assert Day02.collect_matches_part_2({1_698_522, 1_698_528}) == []
    assert Day02.collect_matches_part_2({446_443, 446_449}) == [446_446]
    assert Day02.collect_matches_part_2({38_593_856, 38_593_862}) == [38_593_859]
    assert Day02.collect_matches_part_2({565_653, 565_659}) == [565_656]
    assert Day02.collect_matches_part_2({824_824_821, 824_824_827}) == [824_824_824]
    assert Day02.collect_matches_part_2({2_121_212_118, 2_121_212_124}) == [2_121_212_121]
  end

  test "part2 example input", %{temp_file: temp_file} do
    assert Day02.part2(temp_file) == 4_174_379_265
  end
end
