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

  def max_joltage(nums, digits \\ 2)

  def max_joltage(_nums, 0), do: 0
  def max_joltage([], _digits), do: 0
  def max_joltage(nums, 1), do: Enum.max(nums)

  def max_joltage(nums, digits) do
    {max_n, idx} =
      Enum.take(nums, length(nums) - digits + 1)
      |> Enum.with_index()
      |> Enum.max_by(&elem(&1, 0))

    rest = Enum.drop(nums, idx + 1)

    max_n * Integer.pow(10, digits - 1) + max_joltage(rest, digits - 1)
  end

  def part1(infile) do
    input(infile)
    |> Enum.map(&max_joltage/1)
    |> Enum.sum()
  end

  def part2(infile) do
    input(infile)
    |> Enum.map(&max_joltage(&1, 12))
    |> Enum.sum()
  end

  def main do
    input_path = "lib/day03/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
