require 'rspec'
require 'pry'
require_relative '../lib/grid.rb'

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

  describe "#neighbors" do
    it "returns a subhash containing cardinal direction neighbors" do
      grid = Grid.new(9.times.to_a, 3)
      expect(grid.neighbors([1,1])).to eq({
        [1,0] => 1,
        [0,1] => 3,
        [2,1] => 5,
        [1,2] => 7,
      })
    end
  end
end
