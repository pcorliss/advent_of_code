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

  def dfs(graph, node, target, path, results, filter \\ "") do
    path = [node | path]

    cond do
      node == target ->
        # Found a complete path (reverse because we prepend)
        [Enum.reverse(path) | results]

      true ->
        neighbors = Map.get(graph, node, [])

        Enum.reduce(neighbors, results, fn neighbor, acc ->
          if neighbor in path or neighbor == filter do
            # Avoid cycles — skip nodes already on the current path
            acc
          else
            dfs(graph, neighbor, target, path, acc, filter)
          end
        end)
    end
  end

  def all_paths(graph, start, target, filter \\ "") do
    {paths, _} = dfs_2(graph, start, target, MapSet.new(), %{}, filter)
    paths
  end

  defp dfs_2(graph, node, target, visited, memo, filter) do
    cond do
      # Target reached
      node == target ->
        {[[target]], memo}

      # Cycle detected
      node in visited ->
        {[], memo}

      # filter detected
      node == filter ->
        {[], memo}

      # Cached result
      Map.has_key?(memo, node) ->
        {memo[node], memo}

      true ->
        neighbors = Map.get(graph, node, [])
        visited = MapSet.put(visited, node)

        {paths, memo} =
          Enum.reduce(neighbors, {[], memo}, fn neigh, {acc_paths, acc_memo} ->
            {child_paths, new_memo} = dfs_2(graph, neigh, target, visited, acc_memo, filter)

            # Prepend current node to each child path
            prefixed =
              for path <- child_paths do
                [node | path]
              end

            {acc_paths ++ prefixed, new_memo}
          end)

        # Store in memo
        memo = Map.put(memo, node, paths)
        {paths, memo}
    end
  end

  def part1(infile) do
    graph = input(infile)
    length(dfs(graph, "you", "out", [], []))
  end

  def reverse_graph(graph) do
    graph
    |> Enum.reduce(%{}, fn {node, neighbors}, acc ->
      Enum.reduce(neighbors, acc, fn neigh, acc2 ->
        Map.update(acc2, neigh, [node], fn list -> [node | list] end)
      end)
    end)
  end

  def find_paths(graph) do
    rev_graph = reverse_graph(graph)

    # Slow
    # svr_fft = dfs(graph, "svr", "fft", [], [], "dac")
    # IO.puts("svr->fft: #{length(svr_fft)}")

    # svr_fft = all_paths(graph, "svr", "fft", "dac")
    # IO.puts("svr->fft: #{length(svr_fft)}")

    # Fast
    svr_fft = dfs(rev_graph, "fft", "svr", [], [], "dac")
    # IO.puts("svr->fft: #{length(svr_fft)}")

    # Slow
    # svr_dac = dfs(graph, "svr", "dac", [], [], "fft")
    # IO.puts("svr->dac: #{length(svr_dac)}")

    # Alsp Slow
    # svr_dac = all_paths(graph, "svr", "dac", "fft")
    # IO.puts("svr->dac: #{length(svr_dac)}")

    # Also slow
    # svr_dac = dfs(rev_graph, "dac", "svr", [], [], "fft")
    # IO.puts("svr->dac: #{length(svr_dac)}")

    # Slow
    # fft_dac = dfs(graph, "fft", "dac", [], [])
    # IO.puts("fft->dac: #{length(fft_dac)}")

    # Also Slow
    # fft_dac = dfs(rev_graph, "dac", "fft", [], [])
    # IO.puts("fft->dac: #{length(fft_dac)}")

    fft_dac = all_paths(graph, "fft", "dac")
    # IO.puts("fft->dac: #{length(fft_dac)}")

    # Fast
    # dac_fft = dfs(graph, "dac", "fft", [], [])
    # IO.puts("dac->fft: #{length(dac_fft)}")

    # Slow
    # fft_out = dfs(graph, "fft", "out", [], [], "dac")
    # IO.puts("fft->out: #{length(fft_out)}")

    # Fast
    dac_out = dfs(graph, "dac", "out", [], [], "fft")
    # IO.puts("dac->out: #{length(dac_out)}")

    length(svr_fft) * length(fft_dac) * length(dac_out)
    # +
    # length(svr_dac) * length(dac_fft) * length(fft_out)

    # 0
  end

  def part2(infile) do
    graph = input(infile)
    find_paths(graph)
  end

  def main do
    input_path = "lib/day11/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
