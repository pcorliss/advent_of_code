defmodule Day11 do
  def input(infile) do
    File.read!(infile)
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [key | rest] = String.split(line, ": ", trim: true)
      Map.put(acc, key, String.split(List.first(rest), " "))
    end)
  end

  # graph: %{node => [neighbors]}
  # start: starting node
  # target: destination node
  #
  # Returns: list of paths, each path is a list of nodes
  # def all_paths(graph, start, target) do
  #   dfs(graph, start, target, [], [])
  # end

  def dfs(graph, node, target, path, results) do
    path = [node | path]

    cond do
      node == target ->
        # Found a complete path (reverse because we prepend)
        [Enum.reverse(path) | results]

      true ->
        neighbors = Map.get(graph, node, [])

        Enum.reduce(neighbors, results, fn neighbor, acc ->
          if neighbor in path do
            # Avoid cycles — skip nodes already on the current path
            acc
          else
            dfs(graph, neighbor, target, path, acc)
          end
        end)
    end
  end

  def part1(infile) do
    graph = input(infile)
    length(dfs(graph, "you", "out", [], []))
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day11/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
