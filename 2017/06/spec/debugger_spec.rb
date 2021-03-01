require './debugger.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    0  2   7	0
    EOS
  }

  describe Advent::Debugger do
    let(:ad) { Advent::Debugger.new(input) }

    describe "#new" do
      it "inits blocks" do
        expect(ad.blocks).to eq([0,2,7,0])
      end
    end

    describe "#redist!" do
      it "redistributes the largest bank (index 2) to the others" do
        ad.redist!
        expect(ad.blocks).to eq([2,4,1,2])
      end
    end

    describe "#run!" do
      it "returns the number of cycles until a repeated state is hit" do
        expect(ad.run!).to eq(5)
      end
    end

    context "validation" do
    end
  end
end
