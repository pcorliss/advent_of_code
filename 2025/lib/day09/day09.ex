defmodule Day09 do
  def input(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [a, b] = String.split(line, ",")
      {String.to_integer(a), String.to_integer(b)}
    end)

    # |> MapSet.new()
  end

  def part1(infile) do
    points = input(infile)

    for {{a_x, a_y}, i} <- Enum.with_index(points),
        {{b_x, b_y}, j} <- Enum.with_index(points),
        j > i,
        into: [] do
      # area = (abs(a_x - b_x) + 1) * (abs(a_y - b_y) + 1)
      # IO.puts("Area: #{area} A: #{a_x},#{a_y} B: #{b_x}, #{b_y}")
      (abs(a_x - b_x) + 1) * (abs(a_y - b_y) + 1)
    end
    |> Enum.max()
  end

  def draw_border(points) do
    # Produces a list of point pairs and wraps around
    Enum.zip(points, tl(points) ++ [hd(points)])
    |> Enum.reduce(MapSet.new(), fn {{a_x, a_y}, {b_x, b_y}}, border ->
      edge =
        cond do
          a_x == b_x ->
            y_step = if(a_y <= b_y, do: 1, else: -1)
            for y <- a_y..b_y//y_step, do: {a_x, y}

          a_y == b_y ->
            x_step = if(a_x <= b_x, do: 1, else: -1)
            for x <- a_x..b_x//x_step, do: {x, a_y}
        end

      MapSet.union(border, MapSet.new(edge))
    end)
  end

  def border_min_max(points) do
    x_p = Enum.map(points, fn {x, _} -> x end)
    y_p = Enum.map(points, fn {_, y} -> y end)

    {Enum.min(x_p), Enum.max(x_p), Enum.min(y_p), Enum.max(y_p)}
  end

  def outside(border) do
    {min_x, max_x} = border |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = border |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    min_x = min_x - 1
    max_x = max_x + 1
    min_y = min_y - 1
    max_y = max_y + 1

    start = {min_x, min_y}
    # start = {7, 0}

    neighbors = fn {x, y} ->
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x, y - 1}
      ]
      |> Enum.filter(fn {nx, ny} ->
        nx >= min_x and nx <= max_x and ny >= min_y and ny <= max_y
      end)
      |> Enum.reject(&MapSet.member?(border, &1))
    end

    bfs = fn bfs, frontier, visited ->
      case frontier do
        [] ->
          visited

        _ ->
          {new_visited, new_frontier} =
            Enum.reduce(frontier, {visited, []}, fn p, {v, f} ->
              if MapSet.member?(v, p) do
                {v, f}
              else
                ns = neighbors.(p)
                {MapSet.put(v, p), ns ++ f}
              end
            end)

          bfs.(bfs, new_frontier, new_visited)
      end
    end

    bfs.(bfs, [start], MapSet.new())
  end

  def rects(points) do
    for {{a_x, a_y}, i} <- Enum.with_index(points),
        {{b_x, b_y}, j} <- Enum.with_index(points),
        j > i,
        into: [] do
      {{a_x, a_y}, {b_x, b_y}, (abs(a_x - b_x) + 1) * (abs(a_y - b_y) + 1)}
    end
  end

  def rect_edge_points({a_x, a_y}, {b_x, b_y}) do
    x1 = min(a_x, b_x)
    x2 = max(a_x, b_x)
    y1 = min(a_y, b_y)
    y2 = max(a_y, b_y)

    top = for x <- x1..x2, do: {x, y1}
    bottom = for x <- x1..x2, do: {x, y2}
    left = for y <- y1..y2, do: {x1, y}
    right = for y <- y1..y2, do: {x2, y}

    MapSet.new(top ++ bottom ++ left ++ right)
  end

  def part2(infile) do
    points = input(infile)
    rects = rects(points)
    IO.puts("Generated Rects #{length(rects)}")

    border = Day09.draw_border(points)
    IO.puts("Generated border #{MapSet.size(border)}")

    outside = Day09.outside(border)
    IO.puts("Generated Outside Border #{MapSet.size(outside)}")

    {{_, _, area}, _} =
      Enum.sort_by(rects, fn {_, _, area} -> area end, :desc)
      |> Enum.with_index()
      |> Enum.find(fn {{a, b, _}, idx} ->
        if rem(idx, 1000) == 0 do
          IO.puts("Considered #{idx} rects")
        end

        touches_outside =
          rect_edge_points(a, b)
          |> Enum.any?(&MapSet.member?(outside, &1))

        not touches_outside
      end)

    area
  end

  def main do
    input_path = "lib/day09/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
