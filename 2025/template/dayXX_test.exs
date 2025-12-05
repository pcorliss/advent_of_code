defmodule DayXXTest do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = DayXX.input(temp_file)
    assert length(result) == 0
    assert List.first(result) == ""
  end

  test "part1", %{temp_file: temp_file} do
    assert DayXX.part1(temp_file) == 0
  end

  test "part2", %{temp_file: temp_file} do
    assert DayXX.part2(temp_file) == 0
  end
end
