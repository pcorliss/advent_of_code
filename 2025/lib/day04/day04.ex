defmodule Day04 do
  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, grid ->
      String.trim(line)
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == "@" end)
      |> Enum.reduce(grid, fn {_, x}, grid_x_acc ->
        Map.put(grid_x_acc, {x, y}, true)
      end)
    end)
  end

  def adjacent(grid, {x, y}) do
    [
      {-1, -1},
      {-1, 0},
      {-1, 1},
      {0, -1},
      {0, 1},
      {1, -1},
      {1, 0},
      {1, 1}
    ]
    |> Enum.count(fn {d_x, d_y} ->
      grid[{x + d_x, y + d_y}]
    end)
  end

  def part1(infile) do
    grid = input(infile)

    grid
    |> Enum.filter(fn {pos, _} ->
      adjacent(grid, pos) < 4
    end)
    |> Enum.count()
  end

  def part2(infile) do
    input(infile)
  end

  def main do
    input_path = "lib/day04/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    # answer = part2(input_path)
    # IO.puts("Part 2: #{answer}")
  end
end
