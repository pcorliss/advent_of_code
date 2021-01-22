require './lookandsay.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    1
    EOS
  }

  describe Advent::LookAndSay do
    let(:ad) { Advent::LookAndSay.new(input) }

    describe "#new" do
      it "inits the input as an integer" do
        expect(ad.input).to eq([1])
      end
    end

    context "validation" do
      {
        '1' => [1,1],
        '11' => [2,1],
        '21' => [1,2,1,1],
        '1211' => [1,1,1,2,2,1],
        '111221' => [3,1,2,2,1,1],
      }.each do |inp, expected|
        it "takes #{inp} as input and yields #{expected}" do
          ad = Advent::LookAndSay.new(inp)
          expect(ad.step).to eq(expected)
        end
      end

      [
        [1,1],
        [2,1],
        [1,2,1,1],
        [1,1,1,2,2,1],
        [3,1,2,2,1,1],
      ].each_with_index do |expected, steps|
        it "returns #{expected} after #{steps + 1} step(s)" do
          actual = (steps + 1).times.map { ad.step }.last
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
