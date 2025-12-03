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

  def main do
    input_path = "lib/day02/input.txt"

    # input(input_path)
    # |> Enum.each(fn {a, b} -> IO.puts("#{a}-#{b}") end)

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    # answer = part2(input_path)
    # IO.puts("Part 2: #{answer}")
  end
end
