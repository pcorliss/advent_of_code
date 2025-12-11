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

      {parse_state(state_str), parse_button_bits(buttons_str_arr), parse_buttons(buttons_str_arr),
       parse_joltage(joltage_str)}
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

  defp parse_button_bits(buttons_str_arr) do
    buttons_str_arr
    |> Enum.map(fn str ->
      # Removes `(` and `)` chars
      String.slice(str, 1..-2//1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(0, fn idx, acc ->
        acc ||| 1 <<< idx
      end)
    end)
  end

  defp parse_joltage(joltage_str) do
    # Removes `{` and `}` chars
    String.slice(joltage_str, 1..-2//1)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def combinations(list, k), do: do_combinations(list, k)

  defp do_combinations(_, 0), do: [[]]
  defp do_combinations([], _k), do: []

  defp do_combinations([h | t], k) do
    # combinations that include h
    with_h =
      do_combinations(t, k - 1)
      |> Enum.map(fn rest -> [h | rest] end)

    # combinations that exclude h
    without_h =
      do_combinations(t, k)

    with_h ++ without_h
  end

  def find_buttons(start, target, buttons) do
    max_len = length(buttons)

    1..max_len
    |> Enum.find_value(fn k ->
      combinations(buttons, k)
      |> Enum.find(fn combo ->
        apply_combo(start, combo) == target
      end)
    end)
  end

  defp apply_combo(state, combo) do
    Enum.reduce(combo, state, fn button, acc -> bxor(acc, button) end)
  end

  def part1(infile) do
    input(infile)
    |> Enum.map(fn {target, buttons, _, _} ->
      length(find_buttons(0, target, buttons))
    end)
    |> Enum.sum()
  end

  def lp_solve(buttons, target) do
    button_map =
      0..(length(buttons) - 1)
      |> Enum.map(fn idx -> "x#{idx}" end)

    min_line = "min: #{Enum.join(button_map, " + ")};"

    constraints =
      Enum.with_index(target)
      |> Enum.map(fn {_target_val, dim_idx} ->
        # collect buttons affecting this dimension
        coeffs =
          Enum.with_index(buttons)
          |> Enum.filter(fn {btn, _i} -> dim_idx in btn end)
          |> Enum.map(fn {_btn, i} -> "x#{i}" end)

        # skip if no buttons affect this dimension
        if coeffs == [] do
          nil
        else
          "#{Enum.join(coeffs, " + ")} = #{Enum.at(target, dim_idx)};"
        end
      end)
      |> Enum.reject(&is_nil/1)

    int_line = "int #{Enum.join(button_map, ", ")};"
    lines = [min_line] ++ constraints ++ [int_line]
    model = Enum.join(lines, "\n")

    run_model(model)
  end

  def run_model(model) do
    File.write!("model_out.lp", model)

    {output, _} = System.cmd("lp_solve", ["model_out.lp", "-S1"])
    # IO.puts(output)
    # IO.puts("Exit code: #{exit_code}")

    case Regex.run(~r/([0-9]+)/, output) do
      [_, value_str] ->
        {:ok, String.to_integer(value_str)}

      _ ->
        :error
    end
  end

  def part2(infile) do
    input(infile)
    |> Enum.sum_by(fn {_, _, buttons, target} ->
      {_, v} = lp_solve(buttons, target)
      v
    end)
  end

  def main do
    input_path = "lib/day10/input.txt"

    answer = part1(input_path)
    IO.puts("Part 1: #{answer}")
    answer = part2(input_path)
    IO.puts("Part 2: #{answer}")
  end
end
