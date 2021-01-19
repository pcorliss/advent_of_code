require './lights.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    turn on 0,0 through 999,999
    toggle 0,0 through 999,0
    turn off 499,499 through 500,500
    EOS
  }

  describe Advent::Lights do
    let(:ad) { Advent::Lights.new(input) }

    describe "#new" do
      it "inits instructions" do
        expect(ad.instructions.count).to eq(3)
        expect(ad.instructions.first).to eq([:on, [0,0], [999,999]])
      end

      it "inits an empty grid" do
        expect(ad.grid.cells).to eq({})
      end
    end

    describe "#apply!" do
      xit "applies the instructions to the grid" do
        ad.apply!
        expect(ad.grid[0,0]).to eq(0) # First row is turned off by second instruction
        expect(ad.grid[999,0]).to eq(0) # First row is turned off by second instruction
        expect(ad.grid[0,1]).to eq(1) # Second row is untouched after first instruction
        expect(ad.grid[499,499]).to eq(0)
        expect(ad.grid[499,500]).to eq(0)
      end
    end

    describe "#bright_apply!" do
      it "increases brightness by 1" do
        inp = <<~EOS
        turn on 0,0 through 0,0
        turn on 0,0 through 0,0
        turn on 0,0 through 0,0
        EOS
        ad = Advent::Lights.new(inp)
        ad.bright_apply!
        expect(ad.grid[0,0]).to eq(3) # First row is turned off by second instruction
      end

      it "decreases brightness by 1" do
        inp = <<~EOS
        turn on 0,0 through 0,0
        turn on 0,0 through 0,0
        turn off 0,0 through 0,0
        EOS
        ad = Advent::Lights.new(inp)
        ad.bright_apply!
        expect(ad.grid[0,0]).to eq(1)
      end

      it "prevents negative values" do
        inp = <<~EOS
        turn on 0,0 through 0,0
        turn off 0,0 through 0,0
        turn off 0,0 through 0,0
        EOS
        ad = Advent::Lights.new(inp)
        ad.bright_apply!
        expect(ad.grid[0,0]).to eq(0)
      end

      it "increases brightness by 2 when toggle is encountered" do
        inp = <<~EOS
        toggle 0,0 through 0,0
        EOS
        ad = Advent::Lights.new(inp)
        ad.bright_apply!
        expect(ad.grid[0,0]).to eq(2)
      end
    end

    context "validation" do
      xit "increases total brightness" do
        inp = <<~EOS
        toggle 0,0 through 999,999
        EOS
        ad = Advent::Lights.new(inp)
        ad.bright_apply!
        expect(ad.grid.cells.values.sum).to eq(2_000_000)
      end
    end
  end
end
