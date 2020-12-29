require './image.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    123456789012
    EOS
  }

  describe Advent::Image do
    let(:ad) { Advent::Image.new(input, 3, 2) }

    describe "#new" do
      it "instantiates layers" do
        expect(ad.layers.count).to eq(2)
        expect(ad.layers.first).to be_a(Grid)
        expect(ad.layers.first.width).to eq(3)
      end
    end

    describe "#compose_layers" do
      let(:input) { "0222112222120000" }
      let(:ad) { Advent::Image.new(input, 2, 2) }

      it "yields a new grid with the same width" do
        expect(ad.compose_layers).to be_a(Grid)
        expect(ad.compose_layers.width).to eq(2)
      end

      it "yields pixels" do
        expect(ad.compose_layers.cells).to eq(
          [0,0] => 0,
          [1,0] => 1,
          [0,1] => 1,
          [1,1] => 0
        )
      end
    end

    context "validation" do
      let(:input) { "0222112222120000" }
      let(:ad) { Advent::Image.new(input, 2, 2) }

      it "produces a final image" do
        expected = <<~EOS
          01
          10
        EOS
        expected.chomp!
        expect(ad.compose_layers.render).to eq(expected)
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
