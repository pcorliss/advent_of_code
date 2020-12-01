require '../2020.rb'
require 'rspec'

describe Advent do
  let(:input) {
    <<~EOS
      1721
      979
      366
      299
      675
      1456
    EOS
  }
  let(:bad_input) {
    <<~EOS
      1
      2
      3
    EOS
  }

  describe "#sum" do
    it "returns a pair numbers that sum to 2020" do
      ad = Advent::One.new(input)
      expect(ad.sum).to eq([1721,299])
    end

    it "throws an error if it can't find a pair of numbers that sum to 2020" do
      ad = Advent::One.new(bad_input)
      expect { ad.sum }.to raise_error("Failed to find valid pair in input")
    end
  end

  describe "#mult" do
    it "multiplies the values of the 2020 sum" do
      ad = Advent::One.new(input)
      expect(ad.mult).to eq(514579)
    end
  end
end

