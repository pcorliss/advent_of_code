require './dancing.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    s1,x3/4,pe/b
    EOS
  }

  describe Advent::Dancing do
    let(:ad) { Advent::Dancing.new(input) }

    describe "#new" do
      it "inits dance instructions" do
        expect(ad.inst).to eq([
          [:spin, 1],
          [:exchange, 3, 4],
          [:partner, 'e', 'b'],
        ])
      end

      it "inits a line" do
        expect(ad.line).to eq(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"])
      end
    end

    describe "#spin" do
      it "rotates the line by the specified amount" do
        ad.spin(3)
        expect(ad.line).to eq(["n", "o", "p", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"])
      end
    end

    describe "#exchange" do
      it "swaps two elements by position" do
        ad.exchange(2,4)
        expect(ad.line).to eq(["a", "b", "e", "d", "c", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"])
      end
    end

    describe "#partner" do
      it "swaps to elements by value" do
        ad.partner("c", "e")
        expect(ad.line).to eq(["a", "b", "e", "d", "c", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"])
      end
    end

    describe "#run!" do
      it "runs the passes instructions" do
        ad.line = ("a".."e").to_a
        ad.run!
        expect(ad.line.join).to eq("baedc")
      end
    end

    describe "#find_cycle!" do
      it "runs until the line returns to the first iteration" do
        ad.find_cycle!
        expect(ad.line).to eq(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"])
      end

      it "returns the number of cycles" do
        expect(ad.find_cycle!).to eq(30)
      end
    end

    describe "#line_after" do
      it "returns the state of the line after a given number of cycles" do
        ad.line = ("a".."e").to_a
        expect(ad.line_after(0  )).to eq("abcde")
        expect(ad.line_after(300)).to eq("abcde")
        expect(ad.line_after(301)).to eq("baedc")
        expect(ad.line_after(302)).to eq("ceadb")
      end
    end

    context "validation" do
    end
  end
end
