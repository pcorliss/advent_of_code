require '../ticket.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      class: 1-3 or 5-7
      row: 6-11 or 33-44
      seat: 13-40 or 45-50

      your ticket:
      7,1,14

      nearby tickets:
      7,3,47
      40,4,50
      55,2,20
      38,6,12
    EOS
  }

  describe Advent::Ticket do
    let(:ad) { Advent::Ticket.new(input) }

    describe "#new" do
      it "sets your ticket" do
        expect(ad.ticket).to eq([7,1,14])
      end

      it "sets other tickets" do
        expect(ad.tickets).to contain_exactly(
          [7,3,47],
          [40,4,50],
          [55,2,20],
          [38,6,12],
        )
      end

      it "sets the rules" do
        expect(ad.rules).to contain_exactly(
          (1..3),(5..7),(6..11),(33..44),(13..40),(45..50),
        )
        expect(ad.fields).to eq({
          "class" => [(1..3), (5..7)],
          "row" => [(6..11), (33..44)],
          "seat" => [(13..40), (45..50)],
        })
      end
    end

    describe "#invalid_nums" do
      it "returns an empty list if none are invalid" do
        expect(ad.invalid_nums([7,3,47])).to be_empty
      end

      it "returns a list of invalid nums in a ticket" do
        expect(ad.invalid_nums([40,4,50])).to eq([4])
        expect(ad.invalid_nums([55,2,20])).to eq([55])
        expect(ad.invalid_nums([38,6,12])).to eq([12])
      end
    end

    describe "#sum" do
      it "returns the sum of invalid nums" do
        expect(ad.sum).to eq(71)
      end
    end

    describe "#valid_tickets" do
      it "returns only valid tikets" do
        expect(ad.valid_tickets).to contain_exactly([7,3,47])
      end
    end

    describe "#field_mappings" do
      let(:input) {
        <<~EOS
          class: 0-1 or 4-19
          row: 0-5 or 8-19
          seat: 0-13 or 16-19

          your ticket:
          11,13,12

          nearby tickets:
          3,18,9
          15,5,1
          5,9,14
        EOS
      }

      it "returns the field mappings" do
        expect(ad.field_mappings).to eq(["row", "seat", "class"])
      end
    end

    context "validation" do
    end
  end
end
