require './passphrase.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    aa bb cc dd ee
    aa bb cc dd aa
    aa bb cc dd aaa
    EOS
  }

  describe Advent::Passphrase do
    let(:ad) { Advent::Passphrase.new(input) }

    describe "#new" do
      it "inits a passphrase list" do
        expect(ad.phrases.count).to eq(3)
        expect(ad.phrases.first).to eq(%w(aa bb cc dd ee))
      end
    end

    describe "#valid?" do
      it "returns true if there are no repeated elements" do
        expect(ad.valid?(%w(aa bb cc dd ee))).to be_truthy
      end

      it "returns false if there are repeated elements" do
        expect(ad.valid?(%w(aa bb cc dd aa))).to be_falsey
      end
    end

    describe "#valid_anagram?" do
      [
        %w(abcde fghij),
        %w(a ab abc abd abf abj),
        %w(iiii oiii ooii oooi oooo),
      ].each do |phrase|
        it "returns true if the phrase doesn't contain any anagrams - #{phrase}" do
          expect(ad.valid_anagram?(phrase)).to be_truthy
        end
      end

      [
        %w(abcde xyz ecdab),
        %w(oiii ioii iioi iiio),
      ].each do |phrase|
        it "returns false if the phrase contains an anagram - #{phrase}" do
          expect(ad.valid_anagram?(phrase)).to be_falsey
        end
      end

    end

    context "validation" do
    end
  end
end
