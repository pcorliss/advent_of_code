defmodule Day10Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day10.input(temp_file)
    assert length(result) == 3
    {target_state, button_bits, buttons, joltage} = List.first(result)

    assert target_state == 6
    assert button_bits == [8, 10, 4, 12, 5, 3]
    assert buttons == [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]]
    assert joltage == [3, 5, 4, 7]
  end

  test "find_buttons", %{temp_file: temp_file} do
    result = Day10.input(temp_file)
    {target_state, buttons, _, _} = List.first(result)

    assert length(Day10.find_buttons(0, target_state, buttons)) == 2

    {target_state, buttons, _, _} = Enum.at(result, 1)
    assert length(Day10.find_buttons(0, target_state, buttons)) == 3

    {target_state, buttons, _, _} = List.last(result)
    assert length(Day10.find_buttons(0, target_state, buttons)) == 2
  end

  test "part1", %{temp_file: temp_file} do
    assert Day10.part1(temp_file) == 7
  end

  test "lp_solve", %{temp_file: temp_file} do
    result = Day10.input(temp_file)
    {_, _, buttons, target} = List.first(result)
    assert Day10.lp_solve(buttons, target) == {:ok, 10}

    {_, _, buttons, target} = Enum.at(result, 1)
    assert Day10.lp_solve(buttons, target) == {:ok, 12}

    {_, _, buttons, target} = List.last(result)
    assert Day10.lp_solve(buttons, target) == {:ok, 11}
  end

  test "part2", %{temp_file: temp_file} do
    assert Day10.part2(temp_file) == 33
  end
end
