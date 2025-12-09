defmodule Day09Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day09.input(temp_file)
    assert MapSet.size(result) == 8
    assert MapSet.member?(result, {7, 1})
  end

  test "part1", %{temp_file: temp_file} do
    assert Day09.part1(temp_file) == 50
  end

  test "part2", %{temp_file: temp_file} do
    assert Day09.part2(temp_file) == 0
  end
end
