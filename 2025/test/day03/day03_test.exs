defmodule Day03Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
      987654321111111
      811111111111119
      234234234234278
      818181911112111
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day03.input(temp_file)
    assert length(result) == 4
    assert List.first(result) == [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1]
  end

  test "max_joltage", %{temp_file: temp_file} do
    result = Day03.input(temp_file)
    assert Day03.max_joltage(Enum.at(result, 0)) == 98
    assert Day03.max_joltage(Enum.at(result, 1)) == 89
    assert Day03.max_joltage(Enum.at(result, 2)) == 78
    assert Day03.max_joltage(Enum.at(result, 3)) == 92
  end

  test "max_joltage_2", %{temp_file: temp_file} do
    result = Day03.input(temp_file)
    assert Day03.max_joltage(Enum.at(result, 0), 12) == 987_654_321_111
    assert Day03.max_joltage(Enum.at(result, 1), 12) == 811_111_111_119
    assert Day03.max_joltage(Enum.at(result, 2), 12) == 434_234_234_278
    assert Day03.max_joltage(Enum.at(result, 3), 12) == 888_911_112_111
  end

  test "part1", %{temp_file: temp_file} do
    assert Day03.part1(temp_file) == 357
  end

  test "part2", %{temp_file: temp_file} do
    assert Day03.part2(temp_file) == 3_121_910_778_619
  end
end
