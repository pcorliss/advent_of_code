require './match.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Match do
    let(:ad) { Advent::Match.new(input) }

    describe "#new" do
      it "loads strings" do
        expect(ad.strings.count).to eq(4)
        expect(ad.strings.first).to eq('""')
      end
    end

    describe "#code_length" do
      it "handles empty strings" do
        expect(ad.code_length('""')).to eq(2)
      end

      it "handles regular strings" do
        expect(ad.code_length('"abc"')).to eq(5)
      end

      it "handles strings with double-quotes in them" do
        expect(ad.code_length('"aaa\"aaa"')).to eq(10)
      end

      it "handles special chars" do
        expect(ad.code_length('"\x27"')).to eq(6)
      end

      [ 2,5,10,6 ].each_with_index do |expected, idx|
        it "returns #{expected} for #{idx}" do
          expect(ad.code_length(ad.strings[idx])).to eq(expected)
        end
      end
    end

    describe "#str_length" do
      it "handles empty strings" do
        expect(ad.string_length('""')).to eq(0)
      end

      it "handles regular strings" do
        expect(ad.string_length('"abc"')).to eq(3)
      end

      it "handles strings with double-quotes in them" do
        expect(ad.string_length('"aaa\"aaa"')).to eq(7)
      end

      it "handles special chars" do
        expect(ad.string_length('"\x27"')).to eq(1)
      end

      it "handles literal backslashes mixed" do
        expect(ad.string_length('"\\\x27"')).to eq(4)
      end

      [ 0,3,7,1 ].each_with_index do |expected, idx|
        it "returns #{expected} for #{idx}" do
          expect(ad.string_length(ad.strings[idx])).to eq(expected)
        end
      end
    end

    context "validation" do
      it "returns the total code minus the total str length" do
        expect(ad.total_code_minus_str).to eq(12)
      end

      it "returns the correct input for cheating" do
        expected = ad.strings.map { |str| ad.cheating_string_length(str) }.sum
        actual = ad.strings.map { |str| ad.string_length(str) }.sum
        expect(actual).to eq(expected)
      end

      it "returns the correct total code for a larger input" do
        ad = Advent::Match.new(File.read('validation_input.txt'))
        expect(ad.total_code_minus_str).to eq(1342)
      end
    end
  end
end
