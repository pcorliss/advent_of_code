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

    elements
    |> Enum.chunk_every(chunk_size)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn list ->
      {Enum.drop(list, -1), List.last(list)}
    end)
  end

  def part2(infile) do
    lines =
      File.read!(infile)
      |> String.trim()
      |> String.split("\n")

    max_line_length =
      Enum.map(lines, &String.length/1)
      |> Enum.max()

    lines
    |> Enum.map(&String.pad_trailing(&1, max_line_length, " "))
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn n ->
      Enum.map(n, &parse_token/1)
      |> Enum.reject(&is_nil/1)
    end)
    |> Enum.chunk_by(&Enum.empty?/1)
    |> Enum.reject(fn group ->
      group == [[]]
    end)
    |> Enum.map(fn group ->
      [first | rest] = group
      {operator, first} = List.pop_at(first, -1)

      nums =
        [first | rest]
        |> Enum.map(fn digits ->
          digits
          |> Enum.join()
          |> String.to_integer()
        end)

      if operator == :* do
        Enum.reduce(nums, 1, fn n, acc -> n * acc end)
      else
        Enum.reduce(nums, 0, fn n, acc -> n + acc end)
      end
    end)
    |> Enum.sum()
  end

  defp parse_token("*"), do: :*
  defp parse_token("+"), do: :+
  defp parse_token(" "), do: nil

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

  def main do
    input_path = "lib/day06/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
