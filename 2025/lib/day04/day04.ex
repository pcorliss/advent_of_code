defmodule Day04 do
  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {line, y}, grid ->
      String.trim(line)
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == "@" end)
      |> Enum.reduce(grid, fn {_, x}, grid_x_acc ->
        MapSet.put(grid_x_acc, {x, y})
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

  def adjacent(grid, {x, y}) do
    @neighbors
    |> Enum.count(fn {d_x, d_y} ->
      MapSet.member?(grid, {x + d_x, y + d_y})
    end)
  end

  def remove_rolls(grid) do
    grid
    |> Enum.filter(fn pos ->
      adjacent(grid, pos) < 4
    end)
    |> Enum.reduce(grid, fn pos, grid_acc ->
      MapSet.delete(grid_acc, pos)
    end)
  end

  def recursive_roll_removal(grid) do
    new_grid = remove_rolls(grid)

    cond do
      MapSet.size(new_grid) == MapSet.size(grid) -> grid
      true -> recursive_roll_removal(new_grid)
    end
  end

  def part1(infile) do
    grid = input(infile)

    grid
    |> Enum.filter(fn pos ->
      adjacent(grid, pos) < 4
    end)
    |> Enum.count()
  end

  def part2(infile) do
    grid = input(infile)
    new_grid = recursive_roll_removal(grid)

    MapSet.size(grid) - MapSet.size(new_grid)
  end

  def main do
    input_path = "lib/day04/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
