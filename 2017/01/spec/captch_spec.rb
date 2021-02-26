require './captch.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      91212129
    EOS
  }

  describe Advent::Captch do
    let(:ad) { Advent::Captch.new(input) }

    describe "#new" do
      it "loads a sequence of digits" do
        expect(ad.digits).to eq([9, 1, 2, 1, 2, 1, 2, 9])
      end
    end

    describe "#matches_next_digits" do
      {
        "1122" => [1,2],
        "1111" => [1,1,1,1],
        "1234" => [],
        "91212129" => [9],
      }.each do |inp, expected|
        it "returns the digits that match their next digit" do
          expect(ad.matches_next_digits(inp)).to eq(expected)
        end
      end
    end

    context "validation" do
    end
  end
end
