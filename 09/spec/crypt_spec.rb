require '../crypt.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
    EOS
  }

  describe Advent::Crypt do
    let(:ad) { Advent::Crypt.new(input) }

    describe "#new" do
      it "loads a list of numbers" do
        expect(ad.nums.count).to eq(20)
        expect(ad.nums.first).to be_a(Integer)
      end
    end

    describe "#compliement_set" do
      it "returns a set of numbers" do
        expect(ad.compliment_set(10)).to be_a(Set)
        expect(ad.compliment_set(10).map(&:class).uniq).to eq([Integer])
      end

      it "returns the previous numbers subtracted from the current position" do
        expect(ad.compliment_set(5)).to eq(Set.new([5,20,25,15,-7]))
      end
    end

    describe "#preamble" do
      it "returns the preamble as a set based on a position" do
        expect(ad.preamble(5)).to eq(Set.new([35,20,15,25,47]))
      end
    end

    describe "#valid?" do
      it "returns true if a compliment exists in the preamble" do
        expect(ad.valid?(5)).to be_truthy
      end

      it "returns false if the compliment doesn't exist" do
        expect(ad.valid?(14)).to be_falsey
      end
    end

    describe "#first_invalid_num" do
      it "finds the first invalid num" do
        expect(ad.first_invalid_num).to eq(127)
      end
    end

    context "validation" do
    end
  end
end
