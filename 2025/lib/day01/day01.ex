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
  end

  def part2(infile) do
    pos = 50

    {_, rotation_list} =
      input(infile)
      |> Enum.reduce({pos, []}, fn {dir, distance}, {cur_pos, acc_list} ->
        d_cycles = div(distance, 100)
        d_offset = rem(distance, 100)

        new_pos = move(cur_pos, dir, d_offset)
        # IO.puts("New Pos A: #{new_pos}")

        # if I end up on zero or 100 add one
        end_on_zero = if rem(new_pos, 100) == 0, do: 1, else: 0

        # If I crossed from positive to negative or vice versa or we cross from 95 to 105
        crossed_zero = crossed_zero?(cur_pos, new_pos)

        # Ensure we're working with numbers < 100 and > 0
        new_pos = wrap(new_pos)

        cycles = d_cycles + crossed_zero + end_on_zero

        # IO.puts("")
        # IO.puts("Change: #{dir} #{distance} Position: #{new_pos} cycles: #{cycles}")
        # IO.puts("Returning: {#{new_pos}, [#{cycles} | len: #{length(acc_list)}]")
        # IO.puts("")

        {new_pos, [cycles | acc_list]}
      end)

    Enum.sum(rotation_list)
  end

  defp move(pos, :L, offset), do: pos - offset
  defp move(pos, :R, offset), do: pos + offset

  defp wrap(pos) when pos < 0, do: pos + 100
  defp wrap(pos) when pos >= 100, do: rem(pos, 100)
  defp wrap(pos), do: pos

  defp crossed_zero?(old, new) do
    cond do
      old < 0 and new > 0 -> 1
      old > 0 and new < 0 -> 1
      old < 100 and new > 100 -> 1
      true -> 0
    end
  end

  def main do
    input_path = "lib/day01/input.txt"
    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")

    # 6913
    # That's not the right answer; your answer is too high
  end
end
