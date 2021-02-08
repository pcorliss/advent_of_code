require './triangles.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<-EOS
  541  588  421
  827  272  126
  660  514  367
  39  703  839
  229  871    3
    EOS
  }

  describe Advent::Triangles do
    let(:ad) { Advent::Triangles.new(input) }

    describe "#new" do
      it "inits triangle specs" do
        expect(ad.triangles.count).to eq(5)
        expect(ad.triangles.first).to eq([541,588,421])
      end
    end

    describe "#valid?" do
      it "returns false for invalid triangles" do
        expect(ad.valid?([1,2,100])).to be_falsey
      end

      it "returns true for valid triangles" do
        expect(ad.valid?([1,2,2])).to be_truthy
      end

      it "order doesn't matter" do
        expect(ad.valid?([25, 10, 5])).to be_falsey
      end
    end

    context "validation" do
    end
  end
end
