defmodule Day08 do
  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn str ->
      Enum.map(str, &String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
  end

  # We skip the sqrt here to save CPU cycles, we still compare apples to apples
  def distance(a, b) do
    {a_x, a_y, a_z} = a
    {b_x, b_y, b_z} = b
    x_d = a_x - b_x
    y_d = a_y - b_y
    z_d = a_z - b_z
    Integer.pow(x_d, 2) + Integer.pow(y_d, 2) + Integer.pow(z_d, 2)
  end

  # Hash keyed on edge distance, mapped to a set of two points
  # If two distances are the same we'll run into trouble but not the case for our data set
  def edges(points) do
    for {a, i} <- Enum.with_index(points),
        {b, j} <- Enum.with_index(points),
        j > i,
        into: %{} do
      {distance(a, b), {a, b}}
    end
  end

  defp points_to_circuits(points) do
    MapSet.new(Enum.map(points, fn p -> MapSet.new([p]) end))
  end

  def connect_points(points, edges, connections) do
    circuits = points_to_circuits(points)

    Map.keys(edges)
    |> Enum.sort()
    |> Enum.take(connections)
    |> Enum.reduce(circuits, fn edge, new_circuits ->
      connect_points_edges(new_circuits, edges[edge])
    end)
  end

  def connect_points_edges(circuits, edge) do
    {a, b} = edge

    {edge_groups, remaining_circuits} =
      MapSet.split_with(circuits, fn circuit ->
        MapSet.member?(circuit, a) or MapSet.member?(circuit, b)
      end)

    new_group = Enum.reduce(edge_groups, &MapSet.union(&2, &1))
    MapSet.put(remaining_circuits, new_group)
  end

  # the last connection which causes all of the junction boxes to form a single circuit
  def last_connection(points, edges) do
    circuits = points_to_circuits(points)

    Map.keys(edges)
    |> Enum.sort()
    |> Enum.reduce_while(circuits, fn edge_d, circ_acc ->
      edge = edges[edge_d]
      new_circuits = connect_points_edges(circ_acc, edge)

      if MapSet.size(new_circuits) > 1 do
        {:cont, new_circuits}
      else
        {:halt, edge}
      end
    end)
  end

  def part1(infile, connections) do
    points = input(infile)
    edges = edges(points)
    circuits = connect_points(points, edges, connections)

    Enum.map(circuits, &MapSet.size/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def part2(infile) do
    points = input(infile)
    edges = edges(points)

    {{a_x, _, _}, {b_x, _, _}} = last_connection(points, edges)

    a_x * b_x
  end

  def main do
    input_path = "lib/day08/input.txt"

    answer = part1(input_path, 1000)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
