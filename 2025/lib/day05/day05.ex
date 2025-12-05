defmodule Day05 do
  def input(infile) do
    [ranges, points] =
      File.read!(infile)
      |> String.trim()
      |> String.split("\n\n")

    ranges =
      String.split(ranges, "\n")
      |> Enum.map(fn range_str ->
        [a, b] =
          String.split(range_str, "-")
          |> Enum.map(&String.to_integer/1)

        a..b
      end)

    points =
      String.split(points, "\n")
      |> Enum.map(&String.to_integer/1)

    {ranges, points}
  end

  def part1(infile) do
    {ranges, points} = input(infile)

    Enum.count(points, fn point ->
      Enum.any?(ranges, fn range -> point in range end)
    end)
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day05/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
