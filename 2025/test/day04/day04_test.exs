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
    assert MapSet.size(result) == 71
    assert MapSet.member?(result, {1, 1}) == true
    assert MapSet.member?(result, {2, 0}) == true
    assert MapSet.member?(result, {0, 0}) == false
  end

  test "adjacent", %{temp_file: temp_file} do
    grid = Day04.input(temp_file)
    assert Day04.adjacent(grid, {4, 4}) == 8
    assert Day04.adjacent(grid, {2, 0}) == 3
  end

  test "part1", %{temp_file: temp_file} do
    assert Day04.part1(temp_file) == 13
  end

  test "remove_rolls", %{temp_file: temp_file} do
    grid = Day04.input(temp_file)
    step1 = Day04.remove_rolls(grid)

    # (71 - 13 removed rolls)
    assert MapSet.size(step1) == 58

    step2 = Day04.remove_rolls(step1)

    assert MapSet.size(step2) == 46
  end

  test "recursive_remove_rolls", %{temp_file: temp_file} do
    grid = Day04.input(temp_file)

    final_grid = Day04.recursive_roll_removal(grid)

    assert MapSet.size(final_grid) == 28
  end

  test "part2", %{temp_file: temp_file} do
    assert Day04.part2(temp_file) == 43
  end
end
