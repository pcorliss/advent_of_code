defmodule Day04 do
  def input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.flat_map(fn
        {"@", x} -> [{x, y}]
        _ -> []
      end)
    end)
    |> MapSet.new()
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
    Enum.count(@neighbors, fn {dx, dy} ->
      MapSet.member?(grid, {x + dx, y + dy})
    end)
  end

  def remove_rolls(grid) do
    MapSet.reject(grid, fn pos -> adjacent(grid, pos) < 4 end)
  end

  def recursive_roll_removal(grid) do
    new_grid = remove_rolls(grid)

    if new_grid == grid do
      grid
    else
      recursive_roll_removal(new_grid)
    end
  end

  def part1(file) do
    grid = input(file)

    Enum.count(grid, fn pos -> adjacent(grid, pos) < 4 end)
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
