require './dragon.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    111100001010
    EOS
  }

  describe Advent::Dragon do
    let(:ad) { Advent::Dragon.new(input) }

    describe "#new" do
      it "inits the input" do
        expect(ad.inp).to eq("111100001010")
      end
    end

    describe "#dragon" do
      {
        "1" => "100",
        "0" => "001",
        "11111" => "11111000000",
        "111100001010" => "1111000010100101011110000",
      }.each do |inp, expected|
        it "expands an input #{inp} into a longer one #{expected}" do
          expect(ad.dragon(inp)).to eq(expected)
        end
      end

      it "accepts a target length and continues encoding until it reaches that length then truncates" do
        expect(ad.dragon("10000", 20)).to eq("10000011110010000111")
      end
    end

    describe "#checksum" do
      # Calculate the checksum only for the data that fits on the disk,
      # If the length of the checksum is even, repeat the process until you end up with a checksum with an odd length.
      # 110010110100 100
      {
        "110010110100" => "100",
        "10000011110010000111" => "01100",
      }.each do |inp, checksum|
        it "retursn the checksum #{checksum} for a given input #{inp}" do
          expect(ad.checksum(inp)).to eq(checksum)
        end
      end
    end

    context "validation" do
      it "yields the correct result for test data" do
        encoded = ad.dragon("10000", 20)
        expect(ad.checksum(encoded)).to eq("01100")
      end
    end
  end
end
