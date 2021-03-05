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

    context "part 2" do
      describe "#new" do
        let(:input) {
          <<~EOS
          1,2,3
          EOS
        }
        it "returns the ascii sequence of the original numbers" do
          expect(ad.lengths_prime).to start_with(49,44,50,44,51)
        end

        it "appends a special sequence" do
          expect(ad.lengths_prime).to eq([49,44,50,44,51,17,31,73,47,23])
        end
      end

      describe "#dense_hash" do
        let(:ad) { Advent::Knots.new(input) }
        it "returns groups of 16 numbers xor'd together" do
          expect(ad.dense_hash.length).to eq(16)
          expect(ad.dense_hash.first).to eq(0)
          expect(ad.dense_hash.last).to eq(0)
        end
      end

      describe "#to_hex" do
        let(:ad) { Advent::Knots.new(input) }
        it "returns hex representation" do
          expect(ad.to_hex).to eq('0'*16*2)
        end
      end

      describe "#run_prime!" do
        # it "runs 64 times" do
        #
        # end
      end

      context "validation" do
        {
          "" => "a2582a3a0e66e6e86e3812dcb672a272",
          "AoC 2017" => "33efeb34ea91902bb2f59c9920caa6cd",
          "1,2,3" => "3efbe78a8d82f29979031a4aa0b16a9d",
          "1,2,4" => "63960835bcdc130f0b66d7ff4f6a5a8e",
        }.each do |inp, expected|
          it "returns the correct hex value #{expected} for '#{inp}' input" do
            ad = Advent::Knots.new(inp)
            ad.run_prime!
            expect(ad.to_hex).to eq(expected)
          end
        end
      end
    end
  end
end
