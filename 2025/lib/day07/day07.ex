defmodule Day07 do
  def input(infile) do
    lines =
      infile
      |> File.read!()
      |> String.split("\n", trim: true)

    # I don't totally get this for comprehension
    splitters =
      for {line, y} <- Enum.with_index(lines),
          {char, x} <- Enum.with_index(String.graphemes(line)),
          char == "^",
          into: MapSet.new() do
        {x, y}
      end

    [first_line | _] = lines

    start_x =
      first_line
      |> String.graphemes()
      |> Enum.find_index(&(&1 == "S"))

    max_y = length(lines) - 1

    {{start_x, 0}, splitters, max_y}
  end

  def split_row(splitters, beams, y) do
    beams
    |> Enum.reduce({0, MapSet.new()}, fn {b_x, _}, {count, new_beams} ->
      if MapSet.member?(splitters, {b_x, y}) do
        new_beams =
          new_beams
          |> MapSet.put({b_x - 1, y})
          |> MapSet.put({b_x + 1, y})

        {count + 1, new_beams}
      else
        {count, MapSet.put(new_beams, {b_x, y})}
      end
    end)
  end

  def quantum_split_row(splitters, beams, y) do
    beams
    |> Enum.reduce(%{}, fn {{b_x, _}, b_c}, new_beams ->
      if MapSet.member?(splitters, {b_x, y}) do
        new_beams
        |> Map.update({b_x - 1, y}, b_c, &(&1 + b_c))
        |> Map.update({b_x + 1, y}, b_c, &(&1 + b_c))
      else
        Map.update(new_beams, {b_x, y}, b_c, &(&1 + b_c))
      end
    end)
  end

  def part1(infile) do
    {start, splitters, max_y} = input(infile)

    {sum, _} =
      Enum.reduce(1..max_y, {0, MapSet.new([start])}, fn y, {count, beams} ->
        {new_count, new_beams} = split_row(splitters, beams, y)
        {count + new_count, new_beams}
      end)

    sum
  end

  def part2(infile) do
    {start, splitters, max_y} = input(infile)

    1..max_y
    |> Enum.reduce(%{start => 1}, &quantum_split_row(splitters, &2, &1))
    |> Map.values()
    |> Enum.sum()
  end

  def main do
    input_path = "lib/day07/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
