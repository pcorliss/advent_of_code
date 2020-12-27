require '../combo.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    5764801
    17807724
    EOS
  }

  describe Advent::Combo do
    let(:ad) { Advent::Combo.new(input) }

    describe "#new" do
      it "loads the public_keys" do
        expect(ad.public_keys.count).to eq(2)
        expect(ad.public_keys.map(&:class).uniq).to eq([Integer])
      end
    end

    describe "#loop_size" do
      it "returns the loop size" do
        expect(ad.loop_size(5764801)).to eq(8)
      end

      it "returns the loop size when it gets large" do
        expect(ad.loop_size(17807724)).to eq(11)
      end
    end

    describe "#encryption_key" do
      it "returns the encryption key" do
        expect(ad.encryption_key).to eq(14897079)
      end
    end

    context "validation" do
    end
  end
end
