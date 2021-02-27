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

    it "instantiates a filled grid using a string with newlines" do
      grid = Grid.new(
<<~EOS
1##2
#  #
#  #
3##4
      EOS
)
      expect(grid.width).to eq(4)
      expect(grid.cells).to include({
        [0,0] => '1',
        [3,0] => '2',
        [0,3] => '3',
        [3,3] => '4',
      })
    end

    it "instantiates an empty grid using width and height" do
      grid = Grid.new([], 10, 11)
      expect(grid.width).to eq(10)
      expect(grid.height).to eq(11)
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

  describe "#box!" do
    it "takes a beginning end and val" do
      grid.box!([1,1],[2,2],5)
      expect(grid.cells).to eq({
        [1,1] => 5,
        [1,2] => 5,
        [2,1] => 5,
        [2,2] => 5,
      })
    end

    it "takes an operator" do
      grid.box!([1,1],[2,2],-5,:-)
      expect(grid.cells).to eq({
        [1,1] => 5,
        [1,2] => 5,
        [2,1] => 5,
        [2,2] => 5,
      })
    end

    it "takes a block" do
      grid.box!([1,1],[2,2]) do |val|
        val ||= 0
        val += 5
      end
      expect(grid.cells).to eq({
        [1,1] => 5,
        [1,2] => 5,
        [2,1] => 5,
        [2,2] => 5,
      })
    end
  end

  describe "#render" do
    let(:cells) {{
      [0,0] => 0,
      [1,0] => 1,
      [0,1] => 2,
      [1,1] => 3,
    }}
    it "returns a string suitable for printing" do
      grid.cells = cells
      grid.width = 2
      expect(grid.render).to eq("01\n23")
    end

    it "finds the max width and adds spacing" do
      grid.cells = cells
      grid[1,1] = 999
      grid.width = 2
      expect(grid.render).to eq("  0  1\n  2999")
    end

    it "renders padding" do
      grid.cells = cells
      grid.width = 2
      expect(grid.render(1)).to eq(" 0 1\n 2 3")
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

    it "takes an optional argument to handle diagonals as well as cardinal direction neigbors" do
      grid = Grid.new(9.times.to_a, 3)
      expect(grid.neighbors([1,1], true)).to eq({
        [0,0] => 0,
        [1,0] => 1,
        [2,0] => 2,
        [0,1] => 3,
        [2,1] => 5,
        [0,2] => 6,
        [1,2] => 7,
        [2,2] => 8,
      })
    end
  end

  describe "#neighbor_coords" do
    it "returns just the coordinates of the cardinal direction neighbors" do
      grid = Grid.new
      expect(grid.neighbor_coords([1,1])).to contain_exactly(
        [0,1], [2,1], [1,0], [1,2],
      )
    end

    it "takes an optional argument to consider diagonals" do
      grid = Grid.new
      expect(grid.neighbor_coords([1,1], true)).to contain_exactly(
        [0,0], [1,0], [2,0], [0,1],
        [2,1], [0,2], [1,2], [2,2],
      )
    end
  end

  describe "#get" do
    before do
      grid.cells[[1,1]] = true
    end

    it "it gets a value from cells using an array" do
      expect(grid.get([1,1])).to be_truthy
    end

    it "gets a value from cells using params" do
      expect(grid.get(1,1)).to be_truthy
    end

    it "gets a value from cells using array getter ([])" do
      expect(grid[1,1]).to be_truthy
      expect(grid[[1,1]]).to be_truthy
    end
  end

  describe "#set" do
    it "sets a value from cells using array setter ([])" do
      grid[1,1] = 7
      grid[[2,2]] = 13

      expect(grid[1,1]).to eq(7)
      expect(grid[2,2]).to eq(13)
    end
  end

  describe "#find" do
    it "returns nil if it can't find anything" do
      expect(grid.find('@')).to be_nil
    end

    it "returns a single element if it finds a value match" do
      grid[1,1] = '@'
      expect(grid.find('@')).to eq([1,1])
    end
  end

  describe "#find_all" do
    it "returns an empty array if it can't find anything" do
      expect(grid.find_all('@')).to be_empty
    end

    it "returns an array of matching values" do
      grid[1,1] = '@'
      grid[2,2] = '@'
      expect(grid.find_all('@')).to contain_exactly([1,1], [2,2])
    end
  end
end
