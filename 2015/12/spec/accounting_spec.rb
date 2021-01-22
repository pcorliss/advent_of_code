require './accounting.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    [1,2,3]
    EOS
  }

  describe Advent::Accounting do
    let(:ad) { Advent::Accounting.new(input) }

    describe "#new" do
      it "inits the json" do
        expect(ad.json).to eq("[1,2,3]")
      end
    end

    describe "#numbers" do
      it "returns all the numbers in the json" do
        expect(ad.numbers).to eq([1,2,3])
      end

      it "handles negatives" do
        ad = Advent::Accounting.new('[{"a":[-1,1]},[-1,{"a":1}]]')
        expect(ad.numbers).to eq([-1,1,-1,1])
      end
    end

    describe "#non_red_numbers" do
      it "handles a base case" do
        expect(ad.non_red_numbers).to eq([1,2,3])
      end

      it "traverses nested objects and hashes for numbers" do
        ad = Advent::Accounting.new('[1,{"c":"red","b":2},3]')
        expect(ad.non_red_numbers).to eq([1,3])
      end

      it "handles a case where the structure is ignored" do
        ad = Advent::Accounting.new('{"d":"blue","e":[1,2,3,4],"f":5, "g":"red"}')
        expect(ad.non_red_numbers).to eq([])
      end

      it "handles red in an array" do
        ad = Advent::Accounting.new('[1,"red",5]')
        expect(ad.non_red_numbers).to eq([1,5])
      end
    end

    context "validation" do
      let(:input) { File.read './spec_input.txt' }
      it "yields the same answer with filtering off" do
        # ad.debug!
        expect(ad.numbers).to eq(ad.json_numbers)
      end
    end
  end
end
