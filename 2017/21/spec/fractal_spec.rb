require './fractal.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
    EOS
  }

  describe Advent::Fractal do
    let(:ad) { Advent::Fractal.new(input) }

    describe "#new" do
      it "creates a map of grid strings to new strings" do
        expect(ad.rules).to include(
          "..\n.#"        => "##.\n#..\n...",
          ".#.\n..#\n###" => "#..#\n....\n....\n#..#"
        )
      end

      it "stores flips" do
        expect(ad.rules).to include(
          "###\n..#\n.#." => "#..#\n....\n....\n#..#"
        )
      end

      it "stores rotations" do
        expect(ad.rules).to include(
          "#..\n#.#\n##." => "#..#\n....\n....\n#..#"
        )
      end

      it "stores all possible combinations of flips and rotations" do
        expect(ad.rules.count).to eq(12)
      end
    end

    describe "fractalize!" do
      it "transforms a 2x2 grid" do
        grid_str = <<~EOS
        ..
        .#
        EOS
        expected_grid = <<~EOS
        ##.
        #..
        ...
        EOS
        new_grid = ad.fractalize!(Grid.new(grid_str.chomp))
        expect(new_grid.render).to eq(expected_grid.chomp)
      end

      it "transforms a 3x3 grid" do
        grid_str = <<~EOS
        .#.
        ..#
        ###
        EOS
        expected_grid = <<~EOS
        #..#
        ....
        ....
        #..#
        EOS
        new_grid = ad.fractalize!(Grid.new(grid_str.chomp))
        expect(new_grid.render).to eq(expected_grid.chomp)
      end

      it "splits grids evenly divisible by 2" do
        grid_str = <<~EOS
        #..#
        ....
        ....
        #..#
        EOS
        expected_grid = <<~EOS
        ##.##.
        #..#..
        ......
        ##.##.
        #..#..
        ......
        EOS
        new_grid = ad.fractalize!(Grid.new(grid_str.chomp))
        expect(new_grid.render).to eq(expected_grid.chomp)
      end
    end

    context "validation" do
      let(:starting_grid) do
        start = <<~EOS
        .#.
        ..#
        ###
        EOS
        Grid.new(start.chomp)
      end
      let(:expected_grid) { <<~EOS
        ##.##.
        #..#..
        ......
        ##.##.
        #..#..
        ......
        EOS
      }

      it "returns the correct grid" do
        grid = starting_grid
        2.times { grid = ad.fractalize!(grid) }
        expect(grid.render).to eq(expected_grid.chomp)
      end

      it "returns the correct pixel count" do
        grid = starting_grid
        2.times { grid = ad.fractalize!(grid) }
        expect(grid.find_all('#').count).to eq(12)
      end
    end
  end
end
