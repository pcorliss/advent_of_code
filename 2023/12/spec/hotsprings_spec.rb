require './hotsprings.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
    EOS
  }

  describe Advent::Hotsprings do
    let(:ad) { Advent::Hotsprings.new(input) }

    describe "#new" do
      it "inits an arrangement" do
        expect(ad.springs[0]).to eq(['?', '?', '?', '.', '#', '#', '#'])
        expect(ad.springs[1]).to eq(['.', '?', '?', '.', '.', '?', '?', '.', '.', '.', '?', '#', '#', '.'])
      end

      it "inits counts" do
        expect(ad.counts[0]).to eq([1,1,3])
        expect(ad.counts[1]).to eq([1,1,3])
        expect(ad.counts[2]).to eq([1,3,1,6])
      end
    end

    describe "#cont_match?" do
      it "returns true if the spring matches the count" do
        expect(ad.cont_match?(".##..#...###.".chars, [2, 1, 3])).to be_truthy
      end

      it "returns false if the spring does not match the count" do
        expect(ad.cont_match?(".##..#...###.".chars, [2, 1, 4])).to be_falsey
      end
    end

    describe "#arrangements" do
      [1, 4, 1, 1, 4, 10].each_with_index do |expected, idx|
      # [1].each_with_index do |expected, idx|
        it "returns the number of possible arrangements, #{expected}, for spring index #{idx}" do
          # ad.debug!
          spring = ad.springs[idx]
          count = ad.counts[idx]
          expect(ad.arrangements(spring, count)).to eq(expected)
        end
      end
    end

    describe "#possible_arrangements" do
      it "returns the sum of all possible arrangements" do
        expect(ad.possible_arrangements).to eq(21)
      end
    end

    context "validation" do
    end
  end
end
