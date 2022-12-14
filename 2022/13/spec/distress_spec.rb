require './distress.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    [1,1,3,1,1]
    [1,1,5,1,1]
    
    [[1],[2,3,4]]
    [[1],4]
    
    [9]
    [[8,7,6]]
    
    [[4,4],4,4]
    [[4,4],4,4,4]
    
    [7,7,7,7]
    [7,7,7]
    
    []
    [3]
    
    [[[]]]
    [[]]
    
    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    EOS
  }

  describe Advent::Distress do
    let(:ad) { Advent::Distress.new(input) }

    describe "#new" do
      it "instantiates pairs" do
        expect(ad.pairs.count).to eq(8)
        expect(ad.pairs.first).to eq([
          [1,1,3,1,1],
          [1,1,5,1,1]
        ])
      end
    end

    describe "#compare_pair" do
      it "returns -1 if the left side is smaller" do
        left = [1,1,3,1,1]
        right = [1,1,5,1,1]
        expect(ad.compare_pair(left, right)).to eq(-1)
      end

      it "returns 1 if the right side is smaller" do
        left = [1,1,5,1,1]
        right = [1,1,3,1,1]
        expect(ad.compare_pair(left, right)).to eq(1)
      end

      it "returns -1 if the left side runs out of items first" do
        left = [1,1,1]
        right = [1,1,1,1]
        expect(ad.compare_pair(left, right)).to eq(-1)
      end

      it "returns -1 if the left side is smaller even if the right side runs out of items" do
        left = [1,1,1]
        right = [3]
        expect(ad.compare_pair(left, right)).to eq(-1)
      end

      it "returns 1 if the right side runs out of items first" do
        left = [1,1,1,1]
        right = [1,1,1]
        expect(ad.compare_pair(left, right)).to eq(1)
      end

      context "handles mismatched comparisons between integers and lists" do
        context "proper ordering" do
          it "left not in braces" do
            left = [1]
            right = [[1,1]]
            expect(ad.compare_pair(left, right)).to eq(-1)
          end

          it "right not in braces" do
            left = [[1]]
            right = [1]
            expect(ad.compare_pair(left, right)).to eq(-1)
          end
        end

        context "handles improper ordering" do
          it "left not in braces" do
            left= [[1,1]]
            right = [1]
            expect(ad.compare_pair(left, right)).to eq(1)
          end

          it "right not in braces" do
            left = [2]
            right = [[1]]
            expect(ad.compare_pair(left, right)).to eq(1)
          end
        end
      end

      [
        [[1, 1, 3, 1, 1], [1, 1, 5, 1, 1], -1],
        [[[1], [2, 3, 4]], [[1], 4], -1],
        [[9], [[8, 7, 6]], 1],
        [[[4, 4], 4, 4], [[4, 4], 4, 4, 4], -1],
        [[7, 7, 7, 7], [7, 7, 7], 1],
        [[], [3], -1],
        [[[[]]], [[]], 1],
        [[1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9], 1],
      ].each do |left, right, expected|
        it "returns #{expected} for pair #{left} #{right}" do
          expect(ad.compare_pair(left, right)).to eq(expected)
        end
      end

      it "handles edge cases from full input" do
        expect(ad.compare_pair(
          [[[[9], 3, 4, 3], 8], [[4, 6, [4, 2], [1]], 5]],
          [[9, [3, [9, 8, 10, 5], 4, [8], [8, 7, 0, 5]], 6], [], [5]]
        )).to eq(1)
      end
    end

    describe "#idx_of_pairs_in_right_order" do
      it "returns the idx (starting at 1) of the pairs in the right order (-1)" do
        expect(ad.idx_of_pairs_in_right_order).to eq([1,2,4,6])
        expect(ad.idx_of_pairs_in_right_order.sum).to eq(13)
      end
    end

    describe "#add_divider_packets!" do
      it "adds [2] and [6] packets" do
        ad.add_divider_packets!
        expect(ad.pairs.last).to eq([[[2]],[[6]]])
      end
    end

    describe "#sort" do
      let(:sorted_packets) {[
        [],
        [[]],
        [[[]]],
        [1,1,3,1,1],
        [1,1,5,1,1],
        [[1],[2,3,4]],
        [1,[2,[3,[4,[5,6,0]]]],8,9],
        [1,[2,[3,[4,[5,6,7]]]],8,9],
        [[1],4],
        [[2]],
        [3],
        [[4,4],4,4],
        [[4,4],4,4,4],
        [[6]],
        [7,7,7],
        [7,7,7,7],
        [[8,7,6]],
        [9],
      ]}

      it "sorts the packets" do
        expect(ad.sorted_packets).to match_array(sorted_packets)
      end
    end

    describe "#decoder_key" do
      it "returns the idx of the divider packets multiplied" do
        expect(ad.decoder_key).to eq(140)
      end
    end

    context "validation" do
    end
  end
end
