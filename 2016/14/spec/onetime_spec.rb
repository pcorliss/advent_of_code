require './onetime.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    abc
    EOS
  }

  describe Advent::Onetime do
    let(:ad) { Advent::Onetime.new(input) }

    describe "#new" do
      it "inits a salt" do
        expect(ad.salt).to eq('abc')
      end
    end

    describe "#md5" do
      it "returns the hexdigest of the salt and a message 'abcmessage'" do
        expect(ad.md5('message')).to eq("018f70f84393d558e6b373b4e39a91c8")
      end
    end

    describe "#find_keys" do
      it "takes an int of md5s to generate and populates candidates with matches" do
        ad.find_keys(19)
        expect(ad.candidates).to include([18, '8', '0034e0923cc38887a57bd7b1d4f953df'])
      end

      it "keeps track of the position and increments it" do
        ad.find_keys(18)
        expect(ad.candidates).to be_empty
        ad.find_keys(1)
        expect(ad.candidates).to_not be_empty
      end

      it "marks keys and removes them from candidates" do
        ad.find_keys(39 + 1)
        candidate = [39, 'e', "347dac6ee8eeea4652c7476d0f97bee5"]
        expect(ad.candidates).to include(candidate)
        ad.find_keys(800)
        expect(ad.candidates).to_not include(candidate)
        expect(ad.keys).to include(candidate)
      end

      it "marks all needed keys" do
        ad.find_keys(22728 + 1 + 1000)
        expect(ad.keys.count).to eq(64)
        expect(ad.keys.max).to eq([22728, 'c', "26ccc731a8706e0c4f979aeb341871f0"])
      end

      it "accepts an argument to enable stretching" do
        ad.find_keys(90, true)
        expect(ad.keys.sort.first).to eq([10, 'e', '4a81e578d9f43511ab693eee1a75f194'])
      end

      # Expensive operation
      xit "marks all needed stretch keys" do
        ad.find_keys(22859 + 1, true)
        expect(ad.keys.sort[63]).to eq([22551, 'f', '2df6e9378c3c53abed6d3508b6285fff'])
      end
    end

    describe "#stretch" do
      it "rehashes a key 2016 times" do
        expect(ad.stretch('0')).to eq('a107ff634856bb300138cac6568c0f24')
      end
    end

    context "validation" do

    end
  end
end
