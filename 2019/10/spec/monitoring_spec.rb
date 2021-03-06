require './monitoring.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
.#..#
.....
#####
....#
...##
    EOS
  }

  let(:inputs) {
    h = {}
    h[:input_orig] = input
    h[:input_a] = <<~EOS
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
EOS
   h[:input_b] = <<~EOS
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
EOS
  h[:input_c] = <<~EOS
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
EOS
  h[:input_d] = <<~EOS
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
EOS
  h
  }
  describe Advent::Monitoring do
    let(:ad) { Advent::Monitoring.new(input) }

    describe "#new" do
      it "instantiates a sparse grid of asteroids" do
        expect(ad.asteroids.cells.count).to eq(10)
      end
    end

    describe "#best_location" do
      it "selects the asteroid with the most visible asteroids" do
        expect(ad.best_location).to eq([3,4])
      end
    end

    describe "#visible_from" do
      it "returns the count of visible asteroids from a specific location" do
        expect(ad.visible_from([3,4])).to eq(8)
      end
    end

    context "validation" do
      [
        {input: :input_orig, best: [3,4], count: 8},
        {input: :input_a,    best: [5,8], count: 33},
        {input: :input_b,    best: [1,2], count: 35},
        {input: :input_c,    best: [6,3], count: 41},
        {input: :input_d,    best: [11,13], count: 210},
      ].each do |vals|
        it "finds the best location" do
          ad = Advent::Monitoring.new(inputs[vals[:input]])
          expect(ad.best_location).to eq(vals[:best])
        end

        it "counts the right number of visible asteroids" do
          ad = Advent::Monitoring.new(inputs[vals[:input]])
          expect(ad.visible_from(vals[:best])).to eq(vals[:count])
        end
      end

      {
        1 => [11,12],
        2 => [12,1],
        3 => [12,2],
        10 => [12,8],
        20 => [16,0],
        50 => [16,9],
        100 => [10,16],
        199 => [9,6],
        200 => [8,2],
        201 => [10,9],
        299 => [11,1],
      }.each do |num, pos|
        it "finds the #{num} asteroid to be vaporized at #{pos}" do
          ad = Advent::Monitoring.new(inputs[:input_d])
          expect(ad.asteroid_vaporized(num)).to eq(pos)
        end
      end
    end
  end
end

describe Grid do
  let (:grid) { Grid.new }

  describe "#new" do
    it "instantiates an empty infinite grid" do
      expect(grid).to be_a(Grid)
      expect(grid.cells).to be_empty
    end

    it "instnatiates a filled grid given an array and a width" do
      grid = Grid.new(4.times.to_a, 2)
      expect(grid.width).to eq(2)
      expect(grid.cells).to eq({
        [0,0] => 0,
        [1,0] => 1,
        [0,1] => 2,
        [1,1] => 3,
      })
    end
  end

  describe "#cell_direction" do
    it "returns a hash of all the unique angles to all other cells" do
      grid.cells = {
        [1,0] => true,
        [0,2] => true,
        [1,1] => true,
        [1,2] => true,
        [2,2] => true,
      }
      expect(grid.cell_direction[[1,0]].count).to eq(3)
      expect(grid.cell_direction[[0,2]].count).to eq(3)
    end
  end

  describe "#draw!" do
    it "takes a direction, distance and value and marks cells along the route" do
      grid.draw!([0,1], 4, 1)
      expect(grid.pos).to eq([0,4])
      expect(grid.cells.count).to eq(4)
      expect(grid.cells.values.uniq).to eq([1])
      expect(grid.cells.keys).to contain_exactly([0,1],[0,2],[0,3],[0,4])
    end

    it "takes an operator for manipulating values" do
      grid.draw!([0,1], 4, 1, :+)
      grid.draw!([0,-1], 4, 2, :+)
      # Doesn't set origin point so different values will appear
      expect(grid.cells.values).to include(3, 1, 2)
    end
  end

  describe "#trace!" do
    it "takes a direction, distance and value and marks cells along the route with increasing values" do
      grid.trace!([0,1], 3, 3)
      expect(grid.pos).to eq([0,3])
      expect(grid.cells.count).to eq(3)
      expect(grid.cells.values).to eq([4,5,6])
    end
  end

  describe "#render" do
    it "returns a string suitable for printing" do
      grid.cells = {
        [0,0] => 0,
        [1,0] => 1,
        [0,1] => 2,
        [1,1] => 3,
      }
      grid.width = 2
      expect(grid.render).to eq("01\n23")
    end
  end
end
