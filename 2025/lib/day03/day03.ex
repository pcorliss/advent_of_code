defmodule Day03 do
  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.map(fn digit ->
        # IO.inspect({digit, :codepoints, String.codepoints(digit)}, label: "DEBUG")
        String.to_integer(digit)
      end)
    end)
  end

  def max_joltage(nums) do
    {max_n, max_idx} =
      Enum.slice(nums, 0..-2//1)
      |> Enum.with_index()
      |> Enum.reduce({0, -1}, fn {n, idx}, {acc, acc_idx} ->
        if n > acc do
          {n, idx}
        else
          {acc, acc_idx}
        end
      end)

    max_n2 =
      Enum.slice(nums, (max_idx + 1)..-1//1)
      |> Enum.max()

    max_n * 10 + max_n2
  end

  def part1(infile) do
    input(infile)
    |> Enum.map(&max_joltage/1)
    |> Enum.sum()
  end

  def main do
    input_path = "lib/day03/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    # answer = part2(input_path)
    # IO.puts("Part 2: #{answer}")
  end
end
