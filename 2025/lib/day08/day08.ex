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

  def distance(a, b) do
    {a_x, a_y, a_z} = a
    {b_x, b_y, b_z} = b
    # TODO I don't think abx is necessary here
    x_d = abs(a_x - b_x)
    y_d = abs(a_y - b_y)
    z_d = abs(a_z - b_z)
    Integer.pow(x_d, 2) + Integer.pow(y_d, 2) + Integer.pow(z_d, 2)
  end

  # Hash keyed on edge distance, mapped to a set of two points
  def edges(points) do
    Enum.reduce(points, %{}, fn a, a_acc ->
      Enum.reduce(points, a_acc, fn b, h_acc ->
        if a == b do
          h_acc
        else
          d = distance(a, b)
          # TODO There's a bug here where we compute the distance twice
          Map.put(h_acc, d, {a, b})
        end
      end)
    end)
  end

  # sort the edges
  # keep track of points already in a circuit and which circuit they're in
  # Connect the X smallest edges
  # Sum the different circuit sizes and return

  def connect_points(points, edges, connections) do
    circuits = MapSet.new(Enum.map(points, fn p -> MapSet.new([p]) end))

    Map.keys(edges)
    |> Enum.sort()
    |> Enum.take(connections)
    |> Enum.reduce(circuits, fn edge, new_circuits ->
      {a, b} = edges[edge]

      # Two map sets with a and b members
      groups =
        new_circuits
        |> MapSet.filter(fn group ->
          MapSet.member?(group, a) or MapSet.member?(group, b)
        end)

      # if a and b are already connected then group size will be 1
      # Doesn't seem to matter we just waste some cycles without checking here
      # if group size is 2 then we needto merge them
      # Remove from existing mapset
      new_circuits =
        Enum.reduce(groups, new_circuits, &MapSet.delete(&2, &1))

      new_group = Enum.reduce(groups, MapSet.new(), &MapSet.union(&2, &1))
      MapSet.put(new_circuits, new_group)
    end)
  end

  def part1(infile, connections) do
    points = input(infile)
    edges = edges(points)
    circuits = connect_points(points, edges, connections)

    # Enum.each(circuits, fn c ->
    #   IO.puts("Circuit: #{inspect(c)} Size: #{MapSet.size(c)}")
    # end)

    Enum.map(circuits, &MapSet.size/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day08/input.txt"

    answer = part1(input_path, 1000)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
