require './freq.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    12345678
    EOS
  }

  describe Advent::Freq do
    let(:ad) { Advent::Freq.new(input) }

    describe "#new" do
      it "loads the digits from the input" do
        expect(ad.digits).to eq([1,2,3,4,5,6,7,8])
      end
    end

    describe "#base_num" do
      [
        [1, 0, -1, 0, 1, 0, -1],
        [0, 1, 1, 0, 0, -1, -1, 0, 0],
        [0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1],
      ].each_with_index do |set, i|
        set.each_with_index do |digit, j|
          it "returns the correct multiplier for #{i} digit and #{j} digit" do
            expect(ad.base_num(i, j)).to eq(digit)
          end
        end
      end
    end

    describe "#phase!" do
      it "modifies the digits" do
        ad.phase!
        expect(ad.digits).to eq([4,8,2,2,6,1,5,8])
      end

      {
        0 => [4,8,2,2,6,1,5,8],
        1 => [8,2,2,6,1,5,8],
        2 => [2,2,6,1,5,8],
        3 => [2,6,1,5,8],
        4 => [6,1,5,8],
        5 => [1,5,8],
        6 => [5,8],
        7 => [8],
      }.each do |offset, expected|
        it "accepts an offset #{offset} and ignores digits before it" do
          ad.phase!(offset)
          expect(ad.digits).to eq(expected)
        end
      end
    end

    context "validation" do
      [
        [1,2,3,4,5,6,7,8,],
        [4,8,2,2,6,1,5,8,],
        [3,4,0,4,0,4,3,8,],
        [0,3,4,1,5,5,1,8,],
        [0,1,0,2,9,4,9,8,],
      ].each_with_index do |expected, phase|
        it "produces #{expected} for phase #{phase}" do
          phase.times { ad.phase! }
          expect(ad.digits).to eq(expected)
        end
      end

      {
        "80871224585914546619083218645595" => "24176176",
        "19617804207202209144916044189917" => "73745418",
        "69317163492948606335995924319873" => "52432133",
      }.each do |inp, expected|
        it "takes #{inp} as input and produces #{expected} as first 8 digits" do
          ad = Advent::Freq.new(inp)
          100.times { ad.phase! }
          expect(ad.digits.first(8).map(&:to_s).join("")).to eq(expected)
        end
      end

      {
        "03036732577212944063491565474664" => "84462026",
        "02935109699940807407585447034323" => "78725270",
        "03081770884921959731165446850517" => "53553731",
      }.each do |inp, expected|
        it "takes #{inp} as input and produces #{expected} as 8 digits after offset" do
          ad = Advent::Freq.new(inp*10_000)
          offset = inp.chars.first(7).join('').to_i
          ad.set_offset(offset)
          100.times { |i| ad.phase_ignore_base }
          expect(ad.digits.first(8).map(&:to_s).join("")).to eq(expected)
        end
      end
    end
  end
end
