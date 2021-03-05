require './knots.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    3, 4, 1, 5
    EOS
  }

  describe Advent::Knots do
    let(:ad) { Advent::Knots.new(input, 5) }

    describe "#new" do
      it "inits lengths" do
        expect(ad.lengths).to eq([3,4,1,5])
      end

      # it "inits circular linked list" do
      #   expect(ad.ring).to be_a(Advent::CircularLinkedList)
      #   expect(ad.ring.length).to eq(5)
      # end
      #
      # it "inits a current pos" do
      #   expect(ad.pos).to eq(ad.ring.first)
      # end

      it "inits an array" do
        expect(ad.ring.length).to eq(5)
        expect(ad.ring.first).to eq(0)
        expect(ad.ring.last).to eq(4)
      end

      it "inits a current pos" do
        expect(ad.pos).to eq(0)
      end

      it "inits a skip size" do
        expect(ad.skip).to eq(0)
      end
    end

    describe "#twist!" do
      it "reverses some elements" do
        ad.twist!(3)
        expect(ad.ring).to eq([2, 1, 0, 3, 4])
      end

      it "increments the pos by the length" do
        ad.twist!(3)
        expect(ad.pos).to eq(3)
      end

      it "increments the skip size by 1" do
        ad.twist!(3)
        expect(ad.skip).to eq(1)
      end

      it "increments the pos by the length and the skip size and wraps" do
        ad.twist!(3)
        ad.twist!(4)
        expect(ad.pos).to eq(3)
        expect(ad.skip).to eq(2)
      end
    end

    describe "#run!" do
      it "runs the full length set" do
        ad.run!
        expect(ad.ring).to eq([3, 4, 2, 1, 0])
        expect(ad.pos).to eq(4)
        expect(ad.skip).to eq(4)
        expect(ad.ring.first(2).inject(:*)).to eq(12)
      end
    end

    context "validation" do
      [
        [[0, 1, 2, 3, 4], 0, 0],
        [[2, 1, 0, 3, 4], 3, 1],
        [[4, 3, 0, 1, 2], 3, 2],
        [[4, 3, 0, 1, 2], 1, 3],
        [[3, 4, 2, 1, 0], 4, 4],
      ].each_with_index do |expected, twists|
        it "yields the correct ordering #{expected[0]} after #{twists}" do
          ordering, pos, skip_size = expected
          # ad.debug!
          twists.times do
            length = ad.lengths.shift
            ad.twist!(length)
          end
          expect(ad.ring).to eq(ordering)
          expect(ad.pos).to eq(pos)
          expect(ad.skip).to eq(skip_size)
        end
      end
    end
  end
end
