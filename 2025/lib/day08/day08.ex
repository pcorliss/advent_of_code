defmodule Day08 do
  def input(infile) do
    infile
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  # We skip the sqrt here to save CPU cycles, we still compare apples to apples
  def distance({ax, ay, az}, {bx, by, bz}) do
    dx = ax - bx
    dy = ay - by
    dz = az - bz
    dx * dx + dy * dy + dz * dz
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
    points
    |> Enum.map(&MapSet.new([&1]))
    |> MapSet.new()
  end

  def connect_points(circuits, edges, connections) do
    Map.keys(edges)
    |> Enum.sort()
    |> Enum.take(connections)
    |> Enum.reduce(circuits, fn edge, new_circuits ->
      connect_points_edges(new_circuits, edges[edge])
    end)
  end

  # Connect to circuits and return the resulting circuit set
  # TODO This would be dramatically faster using a disjoint-set union
  def connect_points_edges(circuits, {a, b}) do
    {edge_groups, remaining} =
      MapSet.split_with(circuits, fn group ->
        MapSet.member?(group, a) or MapSet.member?(group, b)
      end)

    merged = Enum.reduce(edge_groups, &MapSet.union(&2, &1))

    # Dialyzer complains about remaining but I assure you it's a MapSet and is fine
    MapSet.put(remaining, merged)
  end

  # the last connection which causes all of the junction boxes to form a single circuit
  def last_connection(edges, circuits) do
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

  def part1(edges, circuits, connections) do
    connected_circuits = connect_points(circuits, edges, connections)

    Enum.map(connected_circuits, &MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def part2(edges, circuits) do
    {{a_x, _, _}, {b_x, _, _}} = last_connection(edges, circuits)

    a_x * b_x
  end

  def loader(infile) do
    points = input(infile)
    edges = edges(points)
    circuits = points_to_circuits(points)

    {edges, circuits}
  end

  def main do
    input_path = "lib/day08/input.txt"

    {edges, circuits} = loader(input_path)

    answer = part1(edges, circuits, 1000)
    IO.puts("Part 1: #{answer}")
    answer = part2(edges, circuits)
    IO.puts("Part 2: #{answer}")
  end
end
