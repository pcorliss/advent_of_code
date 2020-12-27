require './wires.rb'
require 'rspec'
require 'pry'

describe Advent do
  let(:input) {
    <<~EOS
    R8,U5,L5,D3
    U7,R6,D4,L4
    EOS
  }

  describe Advent::Wires do
    let(:ad) { Advent::Wires.new(input) }

    describe "#new" do
      it "instantiates a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "loads instructions" do
        expect(ad.instructions).to_not be_empty
      end
    end

    describe "#parse!" do
      it "draws on the grid" do
        ad.parse!(["U2","R2","D2","L2"], 1)
        expect(ad.grid.cells.count).to eq(8)
      end
    end

    describe "#intersections" do
      it "finds intersections" do
        expect(ad.intersections).to contain_exactly(
          [3,3],
          [6,5],
        )
      end
    end

    context "validation" do
      it "finds the closest intersection" do
        input = <<~EOS
          R75,D30,R83,U83,L12,D49,R71,U7,L72
          U62,R66,U55,R34,D71,R55,D58,R83
        EOS
        ad = Advent::Wires.new(input)
        expect(ad.distance_intersection).to eq(159)
      end

      it "finds the closeset intersection using alternate inputs" do
        input = <<~EOS
          R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
          U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
        EOS
        ad = Advent::Wires.new(input)
        expect(ad.distance_intersection).to eq(135)
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
end
