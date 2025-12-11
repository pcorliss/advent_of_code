defmodule Day10 do
  import Bitwise

  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [state_str | parts] ->
      buttons_str_arr = Enum.slice(parts, 0, length(parts) - 1)
      joltage_str = List.last(parts)

      {parse_state(state_str), parse_buttons(buttons_str_arr), parse_joltage(joltage_str)}
    end)
  end

  defp parse_state(state_str) do
    # Removes `[` and `]` chars
    String.slice(state_str, 1..-2//1)
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {char, idx}, acc ->
      case char do
        "." -> acc
        "#" -> acc ||| 1 <<< idx
      end
    end)
  end

  defp parse_buttons(buttons_str_arr) do
    buttons_str_arr
    |> Enum.map(fn str ->
      # Removes `(` and `)` chars
      String.slice(str, 1..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp parse_joltage(joltage_str) do
    # Removes `{` and `}` chars
    String.slice(joltage_str, 1..-2//1)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1(infile) do
    input(infile)
    0
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day10/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
