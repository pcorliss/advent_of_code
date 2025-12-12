defmodule Day11Test do
  use ExUnit.Case, async: true

  describe "part 1" do
    setup do
      # Create a temporary file with sample data
      content = ~S"""
      aaa: you hhh
      you: bbb ccc
      bbb: ddd eee
      ccc: ddd eee fff
      ddd: ggg
      eee: out
      fff: out
      ggg: out
      hhh: ccc fff iii
      iii: out
      """

      {:ok, temp_file} = Briefly.create()
      File.write!(temp_file, content)

      {:ok, temp_file: temp_file}
    end

    test "input", %{temp_file: temp_file} do
      result = Day11.input(temp_file)
      assert map_size(result) == 10
      assert result["you"] == ["bbb", "ccc"]
      assert result["ccc"] == ["ddd", "eee", "fff"]
    end

    test "dfs", %{temp_file: temp_file} do
      graph = Day11.input(temp_file)
      paths = Day11.dfs(graph, "you", "out", [], [])
      assert length(paths) == 5
      assert Enum.member?(paths, ["you", "ccc", "fff", "out"])
    end

    test "part1", %{temp_file: temp_file} do
      assert Day11.part1(temp_file) == 5
    end
  end

  describe "part 2" do
    setup do
      # Create a temporary file with sample data
      content = ~S"""
      svr: aaa bbb
      aaa: fft
      fft: ccc
      bbb: tty
      tty: ccc
      ccc: ddd eee
      ddd: hub
      hub: fff
      eee: dac
      dac: fff
      fff: ggg hhh
      ggg: out
      hhh: out
      """

      {:ok, temp_file} = Briefly.create()
      File.write!(temp_file, content)

      {:ok, temp_file: temp_file}
    end

    test "find_paths", %{temp_file: temp_file} do
      graph = Day11.input(temp_file)
      path_count = Day11.find_paths(graph)
      assert path_count == 2
    end

    test "part2", %{temp_file: temp_file} do
      assert Day11.part2(temp_file) == 2
    end
  end
end
