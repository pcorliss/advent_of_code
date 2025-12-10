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

    edges = Enum.zip(points, tl(points) ++ [hd(points)])

    {{_, _, area}, _} =
      Enum.sort_by(rects, fn {_, _, area} -> area end, :desc)
      |> Enum.with_index()
      |> Enum.find(fn {{{a_x, a_y}, {b_x, b_y}, _}, idx} ->
        if rem(idx, 1000) == 0 do
          IO.puts("Considered #{idx} rects")
        end

        x1 = min(a_x, b_x)
        x2 = max(a_x, b_x)
        y1 = min(a_y, b_y)
        y2 = max(a_y, b_y)

        rect = {{x1, y1}, {x2, y2}}

        # Any points within the rectangle
        not Enum.any?(points, fn point ->
          Geometry.point_in_rect(rect, point)
        end) and
          not Enum.any?(edges, fn {{e1_x, e1_y}, {e2_x, e2_y}} ->
            # Any edge midpoints within the rectangle
            {min_x, max_x} = Enum.min_max([e1_x, e2_x])
            {min_y, max_y} = Enum.min_max([e1_y, e2_y])

            m_x = div(max_x - min_x, 2) + min_x
            m_y = div(max_y - min_y, 2) + min_y

            Geometry.point_in_rect(rect, {m_x, m_y})
          end)
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

defmodule Geometry do
  def point_in_rect({{x1, y1}, {x2, y2}}, {p_x, p_y}) do
    p_x > x1 and p_x < x2 and p_y > y1 and p_y < y2
  end

  # Return all 4 edges of a rectangle as {{x1,y1},{x2,y2}}
  def rect_edges({{x1, y1}, {x2, y2}}) do
    left = {{min(x1, x2), min(y1, y2)}, {min(x1, x2), max(y1, y2)}}
    right = {{max(x1, x2), min(y1, y2)}, {max(x1, x2), max(y1, y2)}}
    top = {{min(x1, x2), max(y1, y2)}, {max(x1, x2), max(y1, y2)}}
    bottom = {{min(x1, x2), min(y1, y2)}, {max(x1, x2), min(y1, y2)}}

    [left, right, top, bottom]
  end

  # Check if horizontal rectangle edge truly crosses a vertical polygon edge
  # Returns true only if they overlap in interior, not just endpoints
  defp h_v_intersect?({{hx1, hy}, {hx2, _}}, {{vx, vy1}, {_, vy2}}) do
    # strictly inside vertical range
    # strictly inside horizontal range
    hy > min(vy1, vy2) and hy < max(vy1, vy2) and
      vx > min(hx1, hx2) and vx < max(hx1, hx2)
  end

  # Vertical rectangle edge vs horizontal polygon edge
  defp v_h_intersect?(v, h), do: h_v_intersect?(h, v)

  defp parallel_intersect?({{x1, y1}, {x2, y2}}, {{px1, py1}, {px2, py2}}) do
    cond do
      # both vertical
      x1 == x2 and px1 == px2 ->
        x1 == px1 and ranges_overlap?(y1, y2, py1, py2)

      # both horizontal
      y1 == y2 and py1 == py2 ->
        y1 == py1 and ranges_overlap?(x1, x2, px1, px2)

      true ->
        false
    end
  end

  defp ranges_overlap?(a1, a2, b1, b2) do
    min(a1, a2) < max(b1, b2) and min(b1, b2) < max(a1, a2)
  end

  # Check if two rectangle/polygon edges intersect (excluding touching)
  defp edge_intersect?(r_edge, p_edge) do
    {{rx1, ry1}, {rx2, ry2}} = r_edge
    {{px1, py1}, {px2, py2}} = p_edge

    cond do
      # perpendicular edges
      rx1 == rx2 and py1 == py2 -> v_h_intersect?(r_edge, p_edge)
      ry1 == ry2 and px1 == px2 -> h_v_intersect?(r_edge, p_edge)
      # parallel edges
      true -> parallel_intersect?(r_edge, p_edge)
    end
  end

  # Returns true if any rectangle edge crosses a polygon edge (excluding touching edges)
  def rect_intersects_polygon_edges?(rect, polygon_edges) do
    rect_edges(rect)
    |> Enum.any?(fn r_edge ->
      Enum.any?(polygon_edges, fn p_edge ->
        edge_intersect?(r_edge, p_edge)
      end)
    end)
  end
end
