defmodule Day05Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    {ranges, points} = Day05.input(temp_file)
    assert length(ranges) == 4
    assert length(points) == 6
    assert List.first(ranges) == 3..5
    assert List.first(points) == 1
  end

  test "part1", %{temp_file: temp_file} do
    assert Day05.part1(temp_file) == 3
  end

  test "part2", %{temp_file: temp_file} do
    assert Day05.part2(temp_file) == 0
  end
end
