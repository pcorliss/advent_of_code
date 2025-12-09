defmodule Day09 do
  def input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, ",")
      {String.to_integer(a), String.to_integer(b)}
    end)
    |> MapSet.new()
  end

  def part1(infile) do
    points = input(infile)

    for {{a_x, a_y}, i} <- Enum.with_index(points),
        {{b_x, b_y}, j} <- Enum.with_index(points),
        j > i,
        into: [] do
      # area = (abs(a_x - b_x) + 1) * (abs(a_y - b_y) + 1)
      # IO.puts("Area: #{area} A: #{a_x},#{a_y} B: #{b_x}, #{b_y}")
      (abs(a_x - b_x) + 1) * (abs(a_y - b_y) + 1)
    end
    |> Enum.max()
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day09/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
