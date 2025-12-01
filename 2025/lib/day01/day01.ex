defmodule Day01 do
  def input(infile) do
    File.read!(infile)
    |> String.split()
    |> Enum.map(fn str ->
      case Regex.run(~r/([LR])(\d+)/, str) do
        [_, direction, number] -> {String.to_atom(direction), String.to_integer(number)}
        _ -> {String.to_atom(str), 0}
      end
    end)
  end

  def part1(infile) do
    pos = 50

    {_, counts} =
      input(infile)
      |> Enum.reduce({pos, []}, fn {dir, distance}, {acc, acc_list} ->
        new_pos =
          case dir do
            :L -> acc - distance
            :R -> acc + distance
          end

        {new_pos, [new_pos | acc_list]}
      end)

    # Count how many positions are divisible by 100
    counts
    |> Enum.count(fn pos -> rem(pos, 100) == 0 end)

    # left = Enum.sort(left)
    # right = Enum.sort(right)

    # Enum.zip(left, right)
    # |> Enum.map(fn {a, b} -> abs(a - b) end)
    # |> Enum.sum()
  end

  # def part2(infile) do
  # end

  def main do
    input_path = "lib/day01/input.txt"
    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    # answer = part2(input_path)
    # IO.puts("Part 2: #{answer}")
  end
end
