require './pipes.rb'
require 'rspec'
require 'pry'

describe Advent do
  let(:input) {
    <<~EOS
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    EOS
  }

  let(:input_2) {
    <<~EOS
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    EOS
  }

  # 4 tiles enclosed by the loop
  let(:input_slipping) {
    <<~EOS
    ..........
    .S------7.
    .|F----7|.
    .||....||.
    .||....||.
    .|L-7F-J|.
    .|..||..|.
    .L--JL--J.
    ..........
    EOS
  }

  # 8 tiles enclosed by the loop
  let(:input_larger_slipping) {
    <<~EOS
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    EOS
  }

  # 10 tiles are enclosed by the loop
  let(:input_larger_slipping_with_junk) {
    <<~EOS
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    EOS
  }

  describe Advent::Pipes do
    let(:ad) { Advent::Pipes.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "fills the grid with pipes" do
        expect(ad.grid[1,1]).to eq('S')
        expect(ad.grid[2,1]).to eq('-')
        expect(ad.grid[3,1]).to eq('7')
        expect(ad.grid[1,2]).to eq('|')
        expect(ad.grid[2,2]).to eq('7')
        expect(ad.grid[3,2]).to eq('|')
        expect(ad.grid[1,3]).to eq('L')
        expect(ad.grid[2,3]).to eq('-')
        expect(ad.grid[3,3]).to eq('J')
      end
    end

    describe "#starting_point" do
      it "returns the starting point" do
        expect(ad.starting_point).to eq([1,1])
      end
    end

    describe "#starting_directions" do
      it "returns cells with valid directions based on their pipes" do
        # ad.debug!
        expect(ad.starting_directions).to match_array([[ 1, 0],[ 0, 1]])
      end
    end

    describe "#first_steps" do
      it "returns the first steps" do
        expect(ad.first_steps).to match_array([[2,1],[1,2]])
      end
    end

    describe "#steps" do
      it "returns the steps to the furthest point from start" do
        expect(ad.steps).to eq(4)
      end

      it "handles a more complicated input" do
        ad = Advent::Pipes.new(input_2)
        expect(ad.steps).to eq(8)
      end
    end

    # enclosed by the loop
    # Flood fill with slipping somehow
    # If we only consider tiles in the loop as valid, we can ignore the pipe type of the others
    # If we flood fill from the edge we can probably gaurentee that we're filling the outside.
    # Then use the dimensions of the grid, minus filled, minus loop size to get enclosed counts

    # What if we doubled the grid size, and ignored anything adjacent to an edge?
    # What if we just followed the loop, and marked any cells to right
    # Then took those marked cells to flood fill
    # Then check the edges, and if the flood is on the edge, mark as the outside

    describe "#mark_edge" do
      it "marks the edge of the grid" do
        ad = Advent::Pipes.new(input_slipping)
        # ad.debug!
        edges = ad.mark_edge
        # g = Grid.new()
        # edges.each do |cell|
        #   g[cell] = 'X'
        # end
        expect(edges).to include([7,6],[6,6],[2,6],[3,6])

        # ..........
        # .S------7.
        # .|F----7|.
        # .||....||.
        # .||....||.
        # .|L-7F-J|.
        # .|..||..|.
        # .L--JL--J.
        # ..........
      end
    end

    describe "#flood_fill_count" do
      it "floods for a simple example" do
        ad = Advent::Pipes.new(input_slipping)
        expect(ad.flood_fill_count).to eq(4)
      end

      it "floods the marked edges for a moderate example" do
        ad = Advent::Pipes.new(input_larger_slipping)
        expect(ad.flood_fill_count).to eq(8)
      end

      it "floods the marked edges for a complex example" do
        ad = Advent::Pipes.new(input_larger_slipping_with_junk)
        expect(ad.flood_fill_count).to eq(10)
      end
    end

    describe "#horizontal_ray" do
      it "counts for a simple example" do
        ad = Advent::Pipes.new(input_slipping)
        ad.debug!
        expect(ad.horizontal_ray.count).to eq(4)
      end

      it "counts the marked edges for a moderate example" do
        ad = Advent::Pipes.new(input_larger_slipping)
        ad.debug!
        expect(ad.horizontal_ray.count).to eq(8)
      end

      it "counts the marked edges for a complex example" do
        ad = Advent::Pipes.new(input_larger_slipping_with_junk)
        ad.debug!
        expect(ad.horizontal_ray.count).to eq(10)
      end
    end

    context "validation" do
    end
  end
end
