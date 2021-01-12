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

  describe Advent::RecursiveGrid do
    let(:grid) { Advent::RecursiveGrid.new(input) }

    describe "#neighbors" do
      it "returns adjacent tiles" do
        expect(grid.neighbors([1,1])).to eq({
          [1,0] => '.',
          [0,1] => '#',
          [1,2] => '.',
          [2,1] => '.',
        })
      end

      it "returns recursive tiles on the edges" do
        expect(grid.neighbors([0,0])).to eq({
          [0, 1] => "#",
          [1, 0] => ".",
          [2,1,-1] => ".",
          [1,2,-1] => ".",
        })
        expect(grid.neighbors([4,4])).to eq({
          [3,4] => ".",
          [4,3] => ".",
          [3,2,-1] => ".",
          [2,3,-1] => ".",
        })
      end

      it "returns recursive tiles in the center" do
        expect(grid.neighbors([2,1])).to eq({
          [1,1] => '.',
          [3,1] => '#',
          [2,0] => '.',

          [0,0,1] => '.',
          [1,0,1] => '.',
          [2,0,1] => '.',
          [3,0,1] => '.',
          [4,0,1] => '.',
        })
      end

      it "maintains z-val" do
        expect(grid.neighbors([2,1,3])).to eq({
          [1,1,3] => '.',
          [3,1,3] => '.',
          [2,0,3] => '.',

          [0,0,4] => '.',
          [1,0,4] => '.',
          [2,0,4] => '.',
          [3,0,4] => '.',
          [4,0,4] => '.',
        })
      end
    end
  end

  describe Advent::RecursiveBugs do
    let(:ad) { Advent::RecursiveBugs.new(input) }

    describe "#new" do
      it "inits a 5x5 grid" do
        expect(ad.grid).to be_a(Advent::RecursiveGrid)
        min_x, max_x = ad.grid.cells.keys.map(&:first).minmax
        min_y, max_y = ad.grid.cells.keys.map(&:last).minmax
        expect(min_x).to eq(0)
        expect(max_x).to eq(4)
        expect(min_y).to eq(0)
        expect(max_y).to eq(4)
      end
    end

    context "validation" do
      {
          0 =>  8,
          1 => 27,
         10 => 99,
      }.each do |steps, expected|
        it "#{expected} bugs are present after #{steps} steps" do
          # ad.debug!
          steps.times { ad.step! }
          bug_count = ad.grid.cells.count { |cell, val| val == '#' }
          expect(bug_count).to eq(expected)
        end
      end
    end
  end

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
