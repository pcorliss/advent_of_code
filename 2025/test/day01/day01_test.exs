defmodule Day01Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
      L68
      L30
      R48
      L5
      R60
      L55
      L1
      L99
      R14
      L82
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day01.input(temp_file)
    assert length(result) == 10
    assert Enum.at(result, 0) == {:L, 68}
  end

  test "part1", %{temp_file: temp_file} do
    assert Day01.part1(temp_file) == 3
  end

  test "part2 example input", %{temp_file: temp_file} do
    assert Day01.part2(temp_file) == 6
  end
end
