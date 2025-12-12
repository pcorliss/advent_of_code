defmodule Day12Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    0:
    ###
    ##.
    ##.

    1:
    ###
    ##.
    .##

    2:
    .##
    ###
    ##.

    3:
    ##.
    ###
    ##.

    4:
    ###
    #..
    ###

    5:
    ###
    .#.
    ###

    4x4: 0 0 0 0 2 0
    12x5: 1 0 1 0 2 2
    12x5: 1 0 1 0 3 2
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    {boxes, area_and_box_counts} = Day12.input(temp_file)
    assert length(boxes) == 6
    assert length(area_and_box_counts) == 3

    box = List.first(boxes)
    assert box == MapSet.new([{0, 0}, {1, 0}, {2, 0}, {0, 1}, {1, 1}, {0, 2}, {1, 2}])

    {area, box_count} = List.first(area_and_box_counts)
    assert area == {4, 4}
    assert box_count == [0, 0, 0, 0, 2, 0]
  end

  test "part1", %{temp_file: temp_file} do
    assert Day12.part1(temp_file) == 0
  end

  test "part2", %{temp_file: temp_file} do
    assert Day12.part2(temp_file) == 0
  end
end
