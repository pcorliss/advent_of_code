defmodule Day02 do
  def input(infile) do
    File.read!(infile)
    |> String.split(",")
    |> Enum.map(fn range ->
      String.split(range, "-")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn range -> {List.first(range), List.last(range)} end)
  end

  def part1(infile) do
    input(infile)
    |> Enum.flat_map(&collect_matches/1)
    |> Enum.sum()
  end

  def split_integer(n) do
    string = Integer.to_string(n)

    cond do
      n < 10 ->
        {string, n}

      true ->
        {first_half, _} = String.split_at(string, div(String.length(string), 2))
        {first_half_int, _} = Integer.parse(first_half)
        {first_half, first_half_int}
    end
  end

  def collect_matches({min, max}) do
    # IO.puts("  Collecting #{min}-#{max}")
    {_s, n} = split_integer(min)
    # IO.puts("    Split: #{n}")

    n
    |> Stream.iterate(&(&1 + 1))
    |> Stream.map(&increment_until(&1, min, max))
    |> Stream.take_while(& &1)
    # There's a bug in the code somewhere and we're getting dupes
    |> Enum.uniq()
    |> Enum.to_list()
  end

  # There are some optimizations we could make here
  # We could memoize the doubled string
  # For ranges like 1698522-1698528 there are no matches and never will be matches because of the odd number of digits
  def increment_until(n_int, minimum, maximum) do
    n_str = Integer.to_string(n_int)
    {doubled_int, _} = Integer.parse("#{n_str}#{n_str}")

    # IO.puts("Testing #{doubled_int} against #{minimum} and #{maximum}")

    if doubled_int >= minimum && doubled_int <= maximum do
      doubled_int
    else
      if doubled_int < maximum do
        # IO.puts("Incrementing #{n_int}")
        increment_until(n_int + 1, minimum, maximum)
      else
        nil
      end
    end
  end

  def repeating_pattern(n) when n < 10, do: false

  # Has a repeating pattern if the sequence repeats 2 or more times
  def repeating_pattern(n) do
    # get length of number in base 10
    n_str = Integer.to_string(n)
    l = String.length(n_str)
    # max length of repeating pattern
    max_pattern_l = div(l, 2)

    1..max_pattern_l
    |> Enum.filter(&(rem(l, &1) == 0))
    |> Enum.any?(fn chunk_size ->
      slice = String.slice(n_str, 0, chunk_size)
      chunks = div(l, chunk_size)

      # build the repeated pattern and compare
      repeated = String.duplicate(slice, chunks)
      repeated == n_str
    end)
  end

  def collect_matches_part_2({min_n, max_n}) do
    min_n..max_n
    |> Enum.filter(&repeating_pattern/1)
  end

  def part2(infile) do
    input(infile)
    |> Enum.flat_map(&collect_matches_part_2/1)
    |> Enum.sum()
  end

  def main do
    input_path = "lib/day02/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
