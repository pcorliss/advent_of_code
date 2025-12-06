defmodule Day06 do
  def input(infile) do
    lines =
      File.read!(infile)
      |> String.trim()
      |> String.split("\n")

    elements =
      lines
      |> Enum.map(&String.trim/1)
      |> Enum.flat_map(&String.split(&1))
      |> Enum.map(&parse_token/1)

    chunk_size = div(length(elements), length(lines))

    rotate_grid(elements, chunk_size)
    |> Enum.map(fn list ->
      {Enum.drop(list, -1), List.last(list)}
    end)
  end

  defp rotate_grid(list, length) do
    list
    |> Enum.chunk_every(length)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp parse_token("*"), do: :*
  defp parse_token("+"), do: :+

  defp parse_token(token) do
    {int, ""} = Integer.parse(token)
    int
  end

  def part1(infile) do
    input(infile)
    |> Enum.map(fn {list, op} ->
      if op == :+ do
        Enum.sum(list)
      else
        Enum.reduce(list, 1, fn n, acc -> n * acc end)
      end
    end)
    |> Enum.sum()
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day06/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
