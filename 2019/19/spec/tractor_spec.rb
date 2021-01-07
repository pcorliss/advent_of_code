require './tractor.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Tractor do
    let(:ad) { Advent::Tractor.new(input) }

    describe "#new" do
      it "instantiates a program" do
        expect(ad.program).to be_a(Advent::IntCode)
      end

      it "instantiates a grid" do
        expect(ad.grid).to be_a(Grid)
      end
    end

    describe "#scan" do
      it "scans a single cell" do
        ad.scan([2,2],[2,2])
        expect(ad.grid[2,2]).to eq(0)
      end

      it "scans multiple cells" do
        ad.scan([0,0],[1,1])
        expect(ad.grid[0,0]).to eq(1)
        expect(ad.grid[0,1]).to eq(0)
        expect(ad.grid[1,0]).to eq(0)
        expect(ad.grid[1,1]).to eq(0)
      end
    end

    describe "#find_start" do
      it "finds the beginning cell of the tractor beam" do
        expect(ad.find_start).to eq([5,6])
      end

      it "sets the max_x and max_y" do
        ad.find_start
        expect(ad.max_x).to eq([5,6])
        expect(ad.max_y).to eq([5,6])
      end
    end

    describe "#expand_edge" do
      it "scans around the max_x and max_y" do
        ad.expand_edge
        expect(ad.grid[6,6]).to eq(0)
        expect(ad.grid[6,7]).to eq(1)
        expect(ad.grid[5,7]).to eq(0)
      end

      it "progressively expands the edge" do
        #ad.debug!
        5.times { ad.expand_edge }
        expect(ad.grid[10,11]).to eq(1)
      end
    end

    describe "#find_box" do
      {
        1 => [5,6],
        2 => [14,16],
        3 => [23,26],
        100 => [918,1022],
      }.each do |width, expected|
        it "finds the upper left coordinates for a square of dimensions #{width}" do
          ad.debug!
          res = ad.find_box(width)
          ad.grid[res] = 'X'
          puts ad.grid.render
          expect(res).to eq(expected)
        end
      end
    end

    # context "validation" do
    #   it "scans a big area" do
    #     ad.scan([0,0],[49,49])
    #     expect(ad.grid.cells.values.count {|v| v == 1}).to eq(197)
    #   end
    # end
  end
end
