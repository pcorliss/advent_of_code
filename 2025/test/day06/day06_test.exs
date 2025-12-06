defmodule Day06Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day06.input(temp_file)
    assert length(result) == 4
    assert List.first(result) == {[123, 45, 6], &Enum.product/1}
    assert List.last(result) == {[64, 23, 314], &Enum.sum/1}
  end

  test "part1", %{temp_file: temp_file} do
    assert Day06.part1(temp_file) == 4_277_556
  end

  test "part2", %{temp_file: temp_file} do
    assert Day06.part2(temp_file) == 3_263_827
  end
end
