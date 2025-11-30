defmodule Day01Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "part1", %{temp_file: temp_file} do
    assert Day01.part1(temp_file) == 11
  end

  test "part2", %{temp_file: temp_file} do
    assert Day01.part2(temp_file) == 31
  end
end
