defmodule Day04Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day04.input(temp_file)
    assert length(Map.keys(result)) == 71
    assert result[{1, 1}] == true
    assert result[{2, 0}] == true
    assert result[{0, 0}] == nil
  end

  test "adjacent", %{temp_file: temp_file} do
    grid = Day04.input(temp_file)
    assert Day04.adjacent(grid, {4, 4}) == 8
    assert Day04.adjacent(grid, {2, 0}) == 3
  end

  test "part1", %{temp_file: temp_file} do
    assert Day04.part1(temp_file) == 13
  end

  # test "part2", %{temp_file: temp_file} do
  #   assert Day04.part2(temp_file) == 0
  # end
end
