require '../seat.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      BFFFBBFRRR
      FFFBBBFRRR
      BBFFBBFRLL
    EOS
  }

  let(:expectation) {
    {
      BFFFBBFRRR: { row: 70,  col: 7, seat_id: 567 },
      FFFBBBFRRR: { row: 14,  col: 7, seat_id: 119 },
      BBFFBBFRLL: { row: 102, col: 4, seat_id: 820 }, 
    }
  }

  describe Advent::Five do
    let(:ad) { Advent::Five.new(input) }

    describe "#new" do
    end

    describe "#max_seat_id" do
      it "returns the largest seat id" do
        expect(ad.max_seat_id).to eq(820)
      end
    end

    describe "missing_seat_id" do
      it "returns the missing seat given a contiguous list" do
        input = <<~EOS
          BFFFBBFLLR
          BFFFBBFRLR
          BFFFBBFLRL
          BFFFBBFRLL
          BFFFBBFLLL
        EOS
        ad = Advent::Five.new(input)
        expected = Advent::Seat.new("BFFFBBFLRR").seat_id
        expect(ad.missing_seat_id).to eq(expected)
      end
    end

    context "validation" do
      {
        BFFFBBFRRR: { row: 70,  col: 7, seat_id: 567 },
        FFFBBBFRRR: { row: 14,  col: 7, seat_id: 119 },
        BBFFBBFRLL: { row: 102, col: 4, seat_id: 820 }, 
      }.each do |desc, expected|
        it "for #{desc} seat it sets the correct values" do
          seat = ad.seats[desc.to_s]
          expect(seat.row).to eq(expected[:row])
          expect(seat.col).to eq(expected[:col])
          expect(seat.seat_id).to eq(expected[:seat_id])
        end
      end
    end
  end

  describe Advent::Seat do
    let(:input) { "FBFBBFFRLR" }
    let(:seat) {Advent::Seat.new(input) }

    describe "#seat_id" do
      it "returns the seat id" do
        expect(seat.seat_id).to eq(357)
      end
    end

    describe "#col" do
      it "returns the col" do
        expect(seat.col).to eq(5)
      end
    end

    describe "#row" do
      it "returns the row" do
        expect(seat.row).to eq(44)
      end
    end
  end
end
