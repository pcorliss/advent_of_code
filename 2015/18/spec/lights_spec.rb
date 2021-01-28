require './lights.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      .#.#.#
      ...##.
      #....#
      ..#...
      #.#..#
      ####..
    EOS
  }

  describe Advent::Lights do
    let(:ad) { Advent::Lights.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[0,0]).to eq('.')
        expect(ad.grid[5,5]).to eq('.')
      end
    end

    describe "#step!" do
      it "A light which is off stays off" do
        expect(ad.grid[0,0]).to eq('.')
        ad.step!
        expect(ad.grid[0,0]).to eq('.')
      end

      it "A light which is on turns off when 1 neighbors are on" do
        expect(ad.grid[5,0]).to eq('#')
        ad.step!
        expect(ad.grid[5,0]).to eq('.')
      end

      it "A light which is on turns off when 0 neighbors are on" do
        expect(ad.grid[1,0]).to eq('#')
        ad.step!
        expect(ad.grid[1,0]).to eq('.')
      end

      it "A light which is on stays on when 2 neighbors are on" do
        expect(ad.grid[3,0]).to eq('#')
        ad.step!
        expect(ad.grid[3,0]).to eq('#')
      end

      it "A light which is on stays on when 3 neighbors are on" do
        expect(ad.grid[2,5]).to eq('#')
        ad.step!
        expect(ad.grid[2,5]).to eq('#')
      end

      it "A light which is off turns on if exactly 3 neighbors are on" do
        expect(ad.grid[2,0]).to eq('.')
        ad.step!
        expect(ad.grid[2,0]).to eq('#')
      end
    end

    context "validation" do
      it "steps through different states" do
        init = input
        a = <<~EOS
..##..
..##.#
...##.
......
#.....
#.##..
        EOS
        b = <<~EOS
..###.
......
..###.
......
.#....
.#....
        EOS
        c = <<~EOS
...#..
......
...#..
..##..
......
......
        EOS
        d = <<~EOS
......
......
..##..
..##..
......
......
        EOS

        expect(ad.grid.cells).to eq(Grid.new(init).cells)
        ad.step!
        expect(ad.grid.cells).to eq(Grid.new(a).cells)
        ad.step!
        expect(ad.grid.cells).to eq(Grid.new(b).cells)
        ad.step!
        expect(ad.grid.cells).to eq(Grid.new(c).cells)
        ad.step!
        expect(ad.grid.cells).to eq(Grid.new(d).cells)
      end
    end
  end
end
