defmodule Day07 do
  def input(infile) do
    splitters =
      infile
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.flat_map(fn
          {"^", x} -> [{x, y}]
          _ -> []
        end)
      end)
      |> MapSet.new()

    [first_line | _] =
      infile
      |> File.read!()
      |> String.split("\n", trim: true)

    start_x =
      first_line
      |> String.graphemes()
      |> Enum.find_index(fn char -> char == "S" end)

    lines =
      infile
      |> File.read!()
      |> String.split("\n", trim: true)

    max_y = length(lines) - 1

    {{start_x, 0}, splitters, max_y}
  end

  def split_row(splitters, beams, y) do
    beams
    # Reject not strictly necessary in our implementation
    |> Enum.reject(fn {_, b_y} -> b_y != y - 1 end)
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

  def increment_map(m, keys, incr) do
    Enum.reduce(keys, m, fn k, acc ->
      {_, new_m} =
        Map.get_and_update(acc, k, fn cur ->
          if cur == nil do
            {cur, incr}
          else
            {cur, cur + incr}
          end
        end)

      new_m
    end)
  end

  def quantum_split_row(splitters, beams, y) do
    beams
    |> Enum.reduce({0, %{}}, fn {{b_x, _}, b_c}, {count, new_beams} ->
      if MapSet.member?(splitters, {b_x, y}) do
        new_beams = increment_map(new_beams, [{b_x - 1, y}, {b_x + 1, y}], b_c)
        {count + 1, new_beams}
      else
        {count, increment_map(new_beams, [{b_x, y}], b_c)}
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

    {_, new_beams} =
      Enum.reduce(1..max_y, {0, %{start => 1}}, fn y, {count, beams} ->
        {new_count, new_beams} = quantum_split_row(splitters, beams, y)

        # if new_count > 0 do
        #   IO.puts("Row: #{y} Splits: #{new_count}, Beams: #{inspect(new_beams)}")
        # end

        {count + new_count, new_beams}
      end)

    Map.values(new_beams)
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
