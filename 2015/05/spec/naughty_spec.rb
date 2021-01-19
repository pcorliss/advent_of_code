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

    context "part two" do
      let(:input) {
        <<~EOS
    qjhvhtzxzqqjkmpb
    xxyxx
    uurcxstgmygtbstg
    ieodomkazucvgmuy
        EOS
      }

      describe "#super_nice?" do
        it "returns true if it matches the conditions" do
          expect(ad.super_nice?('xxyxx')).to be_truthy
          expect(ad.super_nice?('qjhvhtzxzqqjkmpb')).to be_truthy
        end

        it "returns false if it doesn't contain a pair of two letters twice" do
          expect(ad.super_nice?('aabdbcc')).to be_falsey
        end

        it "returns false if the repeating pair overlaps" do
          expect(ad.super_nice?('xxx')).to be_falsey
        end

        it "returns true if there are many pairs that don't overlap" do
          expect(ad.super_nice?('xxxx')).to be_truthy
          expect(ad.super_nice?('xxxxx')).to be_truthy
        end

        it "returns false if it doesn't contain a repeating letter with a letter between" do
          expect(ad.super_nice?('aabcdefaa')).to be_falsey
        end
      end

      context "validation" do
        it "counts the nice strings" do
          # ad.list.each { |str| puts "#{str} Nice: #{ad.super_nice?(str)}" }
          expect(ad.super_nice_count).to eq(2)
        end
      end
    end
  end
end
