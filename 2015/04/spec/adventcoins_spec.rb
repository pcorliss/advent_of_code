require './adventcoins.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      abcdef
    EOS
  }

  describe Advent::AdventCoins do
    let(:ad) { Advent::AdventCoins.new(input) }

    describe "#new" do
      it "sets the secret" do
        expect(ad.secret).to eq('abcdef')
      end
    end

    describe "#next_coin" do
      it "returns the next coin" do
        expect(ad.next_coin).to eq(609043)
      end
    end

    context "validation" do
      {
        "abcdef" => 609043,
        "pqrstuv" => 1048970,
      }.each do |inp, expected|
        it "returns #{expected} when the secret is #{inp}" do
          ad = Advent::AdventCoins.new(inp)
          expect(ad.next_coin).to eq(expected)
        end
      end
    end
  end
end
