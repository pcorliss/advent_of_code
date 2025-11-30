defmodule Day01 do
  def input(infile) do
    values =
      File.read!(infile)
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    left = for {v, i} <- Enum.with_index(values), rem(i, 2) == 0, do: v
    right = for {v, i} <- Enum.with_index(values), rem(i, 2) == 1, do: v

    {left, right}
  end

  def part1(infile) do
    {left, right} = input(infile)

    left = Enum.sort(left)
    right = Enum.sort(right)

    Enum.zip(left, right)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2 do
    # your logic here
  end

  def main do
    input_path = "lib/day202401/input.txt"
    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
  end
end
