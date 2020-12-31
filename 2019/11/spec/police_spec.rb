require './police.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    3,13,104,0,104,0,3,13,104,1,104,1,99,0
    EOS
  }

  describe Advent::Police do
    let(:ad) { Advent::Police.new(input) }

    describe "#new" do
      it "inits a direction" do
        expect(ad.direction).to eq(0)
      end

      it "inits an empty grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid.cells).to be_empty
      end

      it "inits a program" do
        expect(ad.program).to be_a(Advent::IntCode)
      end
    end

    describe "#run!" do
      it "uses the first output to paint a panel" do
        ad.run!
        expect(ad.grid.cells[[0,0]]).to eq(0)
      end

      it "uses the second output to turn and move" do
        ad.run!
        expect(ad.grid.pos).to eq([-1,-1])
        expect(ad.direction).to eq(0)
      end

      it "runs until halted" do
        ad.run!
        expect(ad.grid.cells.count).to eq(2)
      end
    end

    context "validation" do
    end
  end
end
