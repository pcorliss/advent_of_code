defmodule DayXX do
  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end

  def part1(infile) do
    input(infile)
  end

  def part2(infile) do
    input(infile)
  end

  def main do
    input_path = "lib/dayXX/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
