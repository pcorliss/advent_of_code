defmodule Day12 do
  def input(infile) do
    sections =
      File.read!(infile)
      |> String.trim()
      |> String.split("\n\n")

    boxes = Enum.take(sections, 6)
    area_and_box_counts = List.last(sections)

    boxes =
      Enum.map(boxes, fn box ->
        [_ | box] = String.split(box, "\n")

        Enum.with_index(box)
        |> Enum.reduce(MapSet.new(), fn {row, y}, acc ->
          String.graphemes(row)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {char, x}, acc ->
            if char == "#" do
              MapSet.put(acc, {x, y})
            else
              acc
            end
          end)
        end)
      end)

    area_and_box_counts =
      String.split(area_and_box_counts, "\n")
      |> Enum.map(fn line ->
        [area_str | box_counts] = String.split(line, ": ")

        area =
          String.split(area_str, "x")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()

        box_counts =
          String.split(List.first(box_counts), " ")
          |> Enum.map(&String.to_integer/1)

        {area, box_counts}
      end)

    {boxes, area_and_box_counts}
  end

  def part1(infile) do
    {boxes, area_and_box_counts} = input(infile)

    # Enum.each(boxes, fn box ->
    #   IO.puts("Box: #{inspect(MapSet.to_list(box))}")
    # end)

    Enum.count(area_and_box_counts, fn {{a_x, a_y}, box_count} ->
      sum =
        Enum.with_index(box_count)
        |> Enum.sum_by(fn {box_n, idx} ->
          area = MapSet.size(Enum.at(boxes, idx))
          box_n * area
        end)

      sum <= a_x * a_y
    end)
  end

  def part2(infile) do
    input(infile)
    0
  end

  def main do
    input_path = "lib/day12/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
