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

  test "part1", %{temp_file: temp_file} do
    assert Day03.part1(temp_file) == 357
  end
end
