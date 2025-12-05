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

  defp range_to_s(range) do
    "#{range.first}..#{range.last}"
  end

  def part2(infile) do
    {ranges, _} = input(infile)

    # Worth a try, OOM
    # range_set =
    #   Enum.reduce(ranges, MapSet.new(), fn r, s ->
    #     MapSet.union(s, MapSet.new(r))
    #   end)

    # MapSet.size(range_set)

    IO.puts("")

    {_, size} =
      Enum.sort(ranges)
      |> Enum.reduce({.., 0}, fn range, {prev_range, acc_size} ->
        IO.puts(
          "Range: #{range_to_s(range)} - Prev Range: #{range_to_s(prev_range)} - Size: #{acc_size}"
        )

        if Range.disjoint?(prev_range, range) do
          IO.puts(
            "  Disjoint - Range: #{range_to_s(range)} - Size: #{acc_size + Range.size(range)}"
          )

          {range, acc_size + Range.size(range)}
        else
          # There's a bug here where if the range is completely contained there will be an issue
          new_range = prev_range.first..max(range.last, prev_range.last)
          new_size = acc_size - Range.size(prev_range) + Range.size(new_range)
          IO.puts("  Not Dis - Range: #{range_to_s(new_range)} - Size: #{new_size}")
          {new_range, new_size}
        end
      end)

    size
  end

  def main do
    input_path = "lib/day05/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
    # Part 2: 334291616815636
    # That's not the right answer; your answer is too low.
  end
end
