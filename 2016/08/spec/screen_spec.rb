require './screen.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
rect 3x2
rotate column x=1 by 1
rotate row y=0 by 4
rotate column x=1 by 1
    EOS
  }

  describe Advent::Screen do
    let(:width) { 7 }
    let(:height) { 3 }
    let(:ad) { Advent::Screen.new(input, width, height) }

    describe "#new" do
      it "inits instructions" do
        expect(ad.instructions.count).to eq(4)
        expect(ad.instructions.first).to eq("rect 3x2")
      end

      it "inits a grid with width and height" do
        expect(ad.grid.width).to eq(width)
        expect(ad.grid.height).to eq(height)
      end
    end

    describe "#interpret_instruction" do
      it "interprets rectangle commands" do
        expect(ad.interpret_instruction("rect 13x14")).to eq([:rect, 13, 14])
      end

      it "interprets rotate commands" do
        expect(ad.interpret_instruction("rotate column x=11 by 12")).to eq([:rotate, :x, 11, 12])
      end
    end

    describe "#apply!" do
      it "applies a rect instruction to the grid" do
        ad.apply!("rect 3x2")
        expect(ad.grid[0,0]).to eq(1)
        expect(ad.grid[2,1]).to eq(1)
        expect(ad.grid[3,2]).to eq(nil)
      end

      it "applies a column rotation instruction to the grid" do
        ad.apply!("rect 3x2")
        ad.apply!("rotate column x=1 by 1")
        expect(ad.grid[1,0]).to eq(nil)
        expect(ad.grid[1,1]).to eq(1)
        expect(ad.grid[1,2]).to eq(1)
      end

      it "applies a row rotation instruction to the grid" do
        ad.apply!("rect 3x2")
        ad.apply!("rotate column x=1 by 1")
        ad.apply!("rotate row y=0 by 4")
        expect(ad.grid[4,0]).to eq(1)
        expect(ad.grid[5,0]).to eq(nil)
        expect(ad.grid[6,0]).to eq(1)
      end

      it "applies a wrapping column rotation" do
        ad.apply!("rect 3x2")
        ad.apply!("rotate column x=1 by 1")
        ad.apply!("rotate row y=0 by 4")
        ad.apply!("rotate column x=1 by 1")
        expect(ad.grid[1,0]).to eq(1)
        expect(ad.grid[1,1]).to eq(nil)
        expect(ad.grid[1,2]).to eq(1)
        expect(ad.grid[1,3]).to eq(nil)
      end
    end

    context "validation" do
      it "produces a proper grid" do
        ad.apply!("rect 3x2")
        # puts "Grid 1:\n#{ad.grid.render}"
        ad.apply!("rotate column x=1 by 1")
        # puts "Grid 2:\n#{ad.grid.render}"
        ad.apply!("rotate row y=0 by 4")
        # puts "Grid 3:\n#{ad.grid.render}"
        ad.apply!("rotate column x=1 by 1")
        lights_on = ad.grid.cells.reject { |pos, cell| cell.nil? }
        # puts "Grid 4:\n#{ad.grid.render}"
        expect(lights_on.keys).to contain_exactly(
                 [1,0],            [4,0], [6,0],
          [0,1],        [2,1],
                 [1,2],
        )
      end
    end
  end
end
