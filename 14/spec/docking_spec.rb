require '../docking.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
    EOS
  }

  describe Advent::Docking do
    let(:ad) { Advent::Docking.new(input) }

    describe "#new" do
      it "sets the and_mask" do
        expect(ad.nand_mask).to eq("10".to_i(2))
      end

      it "sets the or_mask" do
        expect(ad.or_mask).to eq("1000000".to_i(2))
      end

      it "inits_memory" do
        expect(ad.memory).to be_a(Hash)
        expect(ad.memory[8]).to be_a(Integer)
      end

      it "applies_the_mask" do
        expect(ad.memory[7]).to eq(101)
        expect(ad.memory[8]).to eq(64)
      end
    end

    describe "#sum" do
      it "returns the sum of memory after masking" do
        expect(ad.sum).to eq(165)
      end
    end

    context "validation" do
    end
  end
end
