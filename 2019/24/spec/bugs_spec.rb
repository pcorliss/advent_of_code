require './bugs.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
....#
#..#.
#..##
..#..
#....
    EOS
  }

  describe Advent::Bugs do
    let(:ad) { Advent::Bugs.new(input) }

    describe "#new" do
      it "inits a 5x5 grid" do
        expect(ad.grid).to be_a(Grid)
        min_x, max_x = ad.grid.cells.keys.map(&:first).minmax
        min_y, max_y = ad.grid.cells.keys.map(&:last).minmax
        expect(min_x).to eq(0)
        expect(max_x).to eq(4)
        expect(min_y).to eq(0)
        expect(max_y).to eq(4)
      end
    end

    describe "#step!" do
      before do
        ad.step!
      end

      it "bugs die if there are no bugs next to it" do
        expect(ad.grid[4,0]).to eq('.')
      end

      it "bugs die if there are 2 bugs next to it" do
        expect(ad.grid[3,2]).to eq('.')
      end

      it "bugs live if there are exactly 1 bug next to it" do
        expect(ad.grid[3,1]).to eq('#')
      end

      it "empty space becomes infested if exactly one bug is adjacent" do
        expect(ad.grid[0,0]).to eq('#')
      end

      it "empty space becomes infested if exactly two bugs are adjacent" do
        expect(ad.grid[3,0]).to eq('#')
      end

      # neighbors doesn't grab nil cells
      it "purges cells outside the 5x5 grid" do
        expect(ad.grid[-1,1]).to be_nil
      end
    end

    describe "#repeat?" do
      it "returns false" do
        expect(ad.repeat?).to be_falsey
      end

      it "returns true if we've been here before" do
        ad.step!
        ad.instance_variable_set("@grid", Grid.new(input))
        expect(ad.repeat?).to be_truthy
      end
    end

    describe "#biodiversity_rating" do
      let(:input) { <<~EOS
                    .....
                    .....
                    .....
                    #....
                    .#...
                    EOS
      }
      it "calcs the bio rating" do
        expect(ad.biodiversity_rating).to eq(2129920)
      end
    end

    context "validation" do
      it "looks correct after 1 step" do
        expected = <<~EOS
        #..#.
        ####.
        ###.#
        ##.##
        .##..
        EOS
        1.times { ad.step! }
        expected_grid = Grid.new(expected)
        expect(ad.grid.cells).to eq(expected_grid.cells)
      end

      it "looks correct after 2 step" do
        expected = <<~EOS
  #####
  ....#
  ....#
  ...#.
  #.###
        EOS
        2.times { ad.step! }
        expected_grid = Grid.new(expected)
        expect(ad.grid.cells).to eq(expected_grid.cells)
      end

      it "looks correct after 3 step" do
        expected = <<~EOS
  #....
  ####.
  ...##
  #.##.
  .##.#
        EOS
        3.times { ad.step! }
        expected_grid = Grid.new(expected)
        expect(ad.grid.cells).to eq(expected_grid.cells)
      end


      it "looks correct after 4 step" do
        expected = <<~EOS
  ####.
  ....#
  ##..#
  .....
  ##...
        EOS
        4.times { ad.step! }
        expected_grid = Grid.new(expected)
        expect(ad.grid.cells).to eq(expected_grid.cells)
      end
    end
  end
end
