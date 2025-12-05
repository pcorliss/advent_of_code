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

  @neighbors [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1}
  ]

  # TODO convert grid to a set

  def adjacent(grid, {x, y}) do
    @neighbors
    |> Enum.count(fn {d_x, d_y} ->
      grid[{x + d_x, y + d_y}]
    end)
  end

  def remove_rolls(grid) do
    grid
    |> Enum.filter(fn {pos, _} ->
      adjacent(grid, pos) < 4
    end)
    |> Enum.reduce(grid, fn {pos, _}, grid_acc ->
      Map.delete(grid_acc, pos)
    end)
  end

  def recursive_roll_removal(grid) do
    new_grid = remove_rolls(grid)

    cond do
      length(Map.keys(new_grid)) == length(Map.keys(grid)) -> grid
      true -> recursive_roll_removal(new_grid)
    end
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
    grid = input(infile)
    new_grid = recursive_roll_removal(grid)

    length(Map.keys(grid)) - length(Map.keys(new_grid))
  end

  def main do
    input_path = "lib/day04/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
