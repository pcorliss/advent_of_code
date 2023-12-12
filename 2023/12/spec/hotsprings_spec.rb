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

    describe "#partial_match?" do
      it "returns true if the current spring setup is a full match" do
        expect(ad.partial_match?(".##..#...###.".chars, [2, 1, 3])).to be_truthy
      end

      it "returns true if the current spring setup is a partial match" do
        expect(ad.partial_match?(".##..?.?.###.".chars, [2, 1, 3])).to be_truthy
      end

      it "returns false if the current spring doesn't match" do
        expect(ad.partial_match?(".#...?.?.###.".chars, [2, 1, 3])).to be_falsey
        expect(ad.partial_match?(".###.?.?.###.".chars, [2, 1, 3])).to be_falsey
      end

      it "handles shorter strings" do
        expect(ad.partial_match?(".#".chars, [2, 1, 3])).to be_truthy
      end

      it "returns false for shorter strings that don't match" do
        expect(ad.partial_match?(".##".chars, [1, 1, 3])).to be_falsey
      end

      it "handles multiple dots" do
        expect(ad.partial_match?(".#...##...#.".chars, [1, 2, 1])).to be_truthy
      end

      it "handles a problem case" do
        expect(ad.partial_match?(".###.##.#.#".chars, [3,2,1])).to be_falsey
      end
    end

    describe "#chomper" do
      it "returns true if the current spring setup is a full match" do
        expect(ad.chomper(".##..#...###.".chars, [2, 1, 3]).first).to be_truthy
      end

      it "returns two empty arrays if the current spring setup is a full match" do
        expect(ad.chomper(".##..#...###.".chars, [2, 1, 3])[1..-1]).to eq([[],[]])
      end

      it "returns true if the current spring setup is a partial match" do
        expect(ad.chomper(".##..?.?.###.".chars, [2, 1, 3]).first).to be_truthy
      end

      it "returns the remaining string if the current spring setup is a partial match" do
        expect(ad.chomper(".##..?.?.###.".chars, [2, 1, 3])[1]).to eq("?.?.###.".chars)
      end

      it "returns the remaining count if the current spring setup is a partial match" do
        expect(ad.chomper(".##..?.?.###.".chars, [2, 1, 3])[2]).to eq([1,3])
      end

      it "returns false if the current spring doesn't match" do
        expect(ad.chomper(".#...?.?.###.".chars, [2, 1, 3]).first).to be_falsey
        expect(ad.chomper(".###.?.?.###.".chars, [2, 1, 3]).first).to be_falsey
      end

      it "returns false for shorter strings that don't have question marks" do
        expect(ad.chomper(".#".chars, [2, 1, 3]).first).to be_falsey
      end

      it "returns false for shorter strings that don't match" do
        expect(ad.chomper(".##".chars, [1, 1, 3]).first).to be_falsey
      end

      it "handles multiple dots" do
        expect(ad.chomper(".#...##...#.".chars, [1, 2, 1]).first).to be_truthy
      end

      it "handles a problem case" do
        expect(ad.chomper(".###.##.#.#".chars, [3,2,1]).first).to be_falsey
      end

      it "handles cases where matches are partial" do
        bool, spring, count = ad.chomper("##.##?.?.###.".chars, [2, 3, 1, 3])
        expect(bool).to be_truthy
        expect(spring).to eq("##?.?.###.".chars)
        expect(count).to eq([3,1,3])
      end

      it "handles an edge case where the hash ends the string" do
        # ad.debug!
        bool, spring, count = ad.chomper("#.###".chars, [1,3])
        expect(bool).to be_truthy
        expect(spring).to be_empty
        expect(count).to be_empty
      end

      it "handles an edge case where the hash ends the string" do
        # ad.debug!
        bool, spring, count = ad.chomper("#.###".chars, [1,4])
        expect(bool).to be_falsey
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

    describe "#fast_arrangements" do
      [1, 4, 1, 1, 4, 10].each_with_index do |expected, idx|
        it "returns the number of possible arrangements, #{expected}, for spring index #{idx}" do
          # ad.debug!
          spring = ad.springs[idx]
          count = ad.counts[idx]
          expect(ad.fast_arrangements(spring, count)).to eq(expected)
        end
      end

      [
        1,
        # 16384,
        # 1,
        # 16,
        # 2500,
        # 506250,
      ].each_with_index do |expected, idx|
        it "returns the number of possible arrangements, #{expected}, for spring index #{idx} when folded 5 times" do
          # ad.debug!
          ad.unfold!
          spring = ad.springs[idx]
          count = ad.counts[idx]
          expect(ad.fast_arrangements(spring, count)).to eq(expected)
        end
      end
    end

    describe "#faster_arrangements" do
      [
        1,
        4,
        1,
        1,
        4,
        10,
      ].each_with_index do |expected, idx|
        it "returns the number of possible arrangements, #{expected}, for spring index #{idx}" do
          # ad.debug!
          spring = ad.springs[idx]
          count = ad.counts[idx]
          expect(ad.faster_arrangements(spring, count)).to eq(expected)
        end
      end

      [
        1,
        16384,
        1,
        16,
        2500,
        506250,
      ].each_with_index do |expected, idx|
        it "returns the number of possible arrangements, #{expected}, for spring index #{idx} when folded 5 times" do
          # ad.debug!
          ad.unfold!
          spring = ad.springs[idx]
          count = ad.counts[idx]
          expect(ad.faster_arrangements(spring, count)).to eq(expected)
        end
      end
    end

    describe "#possible_arrangements" do
      it "returns the sum of all possible arrangements" do
        expect(ad.possible_arrangements).to eq(21)
      end
    end

    describe "#unfold!" do
      it "multiplies the map by 5" do
        input = '.# 1'
        ad = Advent::Hotsprings.new(input)
        ad.unfold!
        expect(ad.springs.first.join).to eq('.#?.#?.#?.#?.#')
        expect(ad.counts.first).to eq([1,1,1,1,1])
      end

      it "multiplies the map by 5 for larger examples" do
        ad.unfold!
        expect(ad.springs.first.join).to eq('???.###????.###????.###????.###????.###')
        expect(ad.counts.first).to eq([1,1,3,1,1,3,1,1,3,1,1,3,1,1,3])
      end
    end

    context "validation" do
    end
  end
end
