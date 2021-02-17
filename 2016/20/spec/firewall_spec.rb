require './firewall.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      5-8
      0-2
      4-7
    EOS
  }

  describe Advent::Firewall do
    let(:ad) { Advent::Firewall.new(input) }

    describe "#new" do
      it "inits a list of rules" do
        expect(ad.rules.count).to eq(3)
        expect(ad.rules.first).to eq((5..8))
      end
    end

    describe "#lowest" do
      it "returns the lowest possible number" do
        expect(ad.lowest).to eq(3)
      end
    end

    describe "#highest" do
      it "returns the highestt possible number" do
        expect(ad.highest).to eq(4294967295)
      end
    end

    describe "#allowed_count" do
      it "returns the number of allowed ips" do
        expect(ad.allowed_count(9)).to eq(2)
      end
    end

    context "validation" do
    end
  end
end
