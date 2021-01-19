require './naughty.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
ugknbfddgicrmopn
aaa
jchzalrnumimnmhp
haegwjzuvuyypxyu
dvszwmarrgswjxmb
    EOS
  }

  describe Advent::Naughty do
    let(:ad) { Advent::Naughty.new(input) }

    describe "#new" do
      it "inits a list" do
        expect(ad.list.count).to eq(5)
        expect(ad.list.first).to eq('ugknbfddgicrmopn')
      end
    end

    describe "#nice?" do
      it "returns true if it matches the conditions" do
        expect(ad.nice?('ugknbfddgicrmopn')).to be_truthy
      end

      it "returns false if it doesn't have three vowels" do
        expect(ad.nice?('ugknbfddgcrmopn')).to be_falsey
      end
      it "returns false if it doesn't have a letter that appears twice in a row" do
        expect(ad.nice?('ugknbfdgicrmopn')).to be_falsey
      end
      it "returns false if it contains a forbidden string" do
        expect(ad.nice?('ugknbfabddgicrmopn')).to be_falsey
      end
    end

    context "validation" do
      it "counts the nice strings" do
        expect(ad.nice_count).to eq(2)
      end
    end
  end
end
