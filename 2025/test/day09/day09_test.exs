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
    assert length(result) == 8
    assert Enum.member?(result, {7, 1})
  end

  test "part1", %{temp_file: temp_file} do
    assert Day09.part1(temp_file) == 50
  end

  test "draw_border", %{temp_file: temp_file} do
    points = Day09.input(temp_file)
    border = Day09.draw_border(points)

    # Includes the start point
    assert MapSet.member?(border, {7, 1})
    # X Dir
    assert MapSet.member?(border, {8, 1})
    # Y Dir with wrap-around
    assert MapSet.member?(border, {7, 2})

    # Not Border
    assert not MapSet.member?(border, {8, 0})
    assert not MapSet.member?(border, {8, 2})
  end

  test "border_min_max", %{temp_file: temp_file} do
    points = Day09.input(temp_file)
    {x_min, x_max, y_min, y_max} = Day09.border_min_max(points)

    assert x_min == 2
    assert x_max == 11
    assert y_min == 1
    assert y_max == 7
  end

  test "outside", %{temp_file: temp_file} do
    points = Day09.input(temp_file)
    border = Day09.draw_border(points)

    outside = Day09.outside(border)

    assert MapSet.member?(outside, {7, 0})
    assert MapSet.member?(outside, {8, 0})
    assert MapSet.member?(outside, {6, 1})
    assert MapSet.member?(outside, {6, 2})

    assert not MapSet.member?(outside, {7, 1})
  end

  test "rects", %{temp_file: temp_file} do
    points = Day09.input(temp_file)
    r = Day09.rects(points)

    assert length(r) == 28

    max_rect =
      Enum.max_by(r, fn {_, _, area} ->
        area
      end)

    assert max_rect == {{11, 1}, {2, 5}, 50}
  end

  test "part2", %{temp_file: temp_file} do
    assert Day09.part2(temp_file) == 24
  end
end
