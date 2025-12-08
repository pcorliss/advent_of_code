defmodule Day07Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    {start, splitters, max_y} = Day07.input(temp_file)
    assert start == {7, 0}
    assert MapSet.member?(splitters, {0, 0}) == false
    assert MapSet.member?(splitters, {7, 2}) == true
    assert length(MapSet.to_list(splitters)) == 22

    assert max_y == 15
  end

  test "split_row", %{temp_file: temp_file} do
    {start, splitters, _} = Day07.input(temp_file)
    beams = MapSet.new([start])

    {count, new_beams} = Day07.split_row(splitters, beams, 1)
    assert count == 0
    assert MapSet.to_list(new_beams) == [{7, 1}]

    {count, new_beams} = Day07.split_row(splitters, new_beams, 2)
    assert count == 1
    assert MapSet.to_list(new_beams) == [{6, 2}, {8, 2}]
  end

  test "quantum_split_row", %{temp_file: temp_file} do
    {start, splitters, _} = Day07.input(temp_file)
    beams = %{start => 1}

    new_beams = Day07.quantum_split_row(splitters, beams, 1)
    assert new_beams == %{{7, 1} => 1}

    new_beams = Day07.quantum_split_row(splitters, new_beams, 2)
    assert new_beams == %{{6, 2} => 1, {8, 2} => 1}

    new_beams = Day07.quantum_split_row(splitters, new_beams, 3)
    assert new_beams == %{{6, 3} => 1, {8, 3} => 1}

    new_beams = Day07.quantum_split_row(splitters, new_beams, 4)
    assert new_beams == %{{5, 4} => 1, {7, 4} => 2, {9, 4} => 1}

    new_beams = Day07.quantum_split_row(splitters, new_beams, 5)
    assert new_beams == %{{5, 5} => 1, {7, 5} => 2, {9, 5} => 1}

    new_beams = Day07.quantum_split_row(splitters, new_beams, 6)
    assert new_beams == %{{4, 6} => 1, {6, 6} => 3, {8, 6} => 3, {10, 6} => 1}
  end

  test "part1", %{temp_file: temp_file} do
    assert Day07.part1(temp_file) == 21
  end

  test "part2", %{temp_file: temp_file} do
    assert Day07.part2(temp_file) == 40
  end
end
