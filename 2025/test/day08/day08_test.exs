defmodule Day08Test do
  use ExUnit.Case, async: true

  setup do
    # Create a temporary file with sample data
    content = ~S"""
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """

    {:ok, temp_file} = Briefly.create()
    File.write!(temp_file, content)

    {:ok, temp_file: temp_file}
  end

  test "input", %{temp_file: temp_file} do
    result = Day08.input(temp_file)
    assert length(result) == 20
    assert List.first(result) == {162, 817, 812}
    assert List.last(result) == {425, 690, 689}
  end

  test "edges", %{temp_file: temp_file} do
    points = Day08.input(temp_file)
    edges = Day08.edges(points)
    assert map_size(edges) == 190
    # First and last distance
    f = List.first(points)
    l = List.last(points)
    assert edges[100_427] == {f, l}
  end

  test "connect_points", %{temp_file: temp_file} do
    {e, c} = Day08.loader(temp_file)

    # Connects the closest circuits into one group
    circuits = Day08.connect_points(c, e, 1)
    assert MapSet.size(circuits) == 19

    assert MapSet.member?(circuits, MapSet.new([{162, 817, 812}, {425, 690, 689}])) == true

    circuits = Day08.connect_points(c, e, 2)
    assert MapSet.size(circuits) == 18

    assert MapSet.member?(
             circuits,
             MapSet.new([{162, 817, 812}, {425, 690, 689}, {431, 825, 988}])
           ) == true

    circuits = Day08.connect_points(c, e, 3)
    assert MapSet.size(circuits) == 17

    assert MapSet.member?(
             circuits,
             MapSet.new([{906, 360, 560}, {805, 96, 715}])
           ) == true

    #  The next two junction boxes are 431,825,988 and 425,690,689. Because these two junction boxes were already in the same circuit, nothing happens!
    circuits = Day08.connect_points(c, e, 4)
    assert MapSet.size(circuits) == 17

    circuits = Day08.connect_points(c, e, 10)
    assert MapSet.size(circuits) == 11
  end

  test "part1", %{temp_file: temp_file} do
    {e, c} = Day08.loader(temp_file)
    assert Day08.part1(e, c, 10) == 40
  end

  test "last_connection", %{temp_file: temp_file} do
    {e, c} = Day08.loader(temp_file)
    assert Day08.last_connection(e, c) == {{216, 146, 977}, {117, 168, 530}}
  end

  test "part2", %{temp_file: temp_file} do
    {e, c} = Day08.loader(temp_file)
    assert Day08.part2(e, c) == 25272
  end
end
