require './compress.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
ADVENT contains no markers
and decompresses to itself with no changes, resulting in a decompressed length of 6.
    EOS
  }

  describe Advent::Compress do
    let(:ad) { Advent::Compress.new(input) }

    describe "#new" do
      it "inits a a large string, ignoring whitespace" do
        expect(ad.string.length).to eq(94)
        expect(ad.string.lines.count).to eq(1)
        expect(ad.string).to start_with('ADVENTcontainsno')
      end
    end

    describe "#decode" do
      it "decodes a string with no markers as itself" do
        expect(ad.decode("TheQuickBrownFox")).to eq("TheQuickBrownFox")
      end

      it "handles a single char repeating" do
        expect(ad.decode("A(1x5)BC")).to eq("ABBBBBC")
      end

      it "handles multiple chars repeating" do
        expect(ad.decode("(3x3)XYZ")).to eq("XYZXYZXYZ")
      end

      it "ignores markers within repeating sequences" do
        expect(ad.decode("(6x1)(1x3)A")).to eq("(1x3)A")
      end

      it "handles multiple instructions in a string" do
        expect(ad.decode("A(2x2)BCD(2x2)EFG")).to eq("ABCBCDEFEFG")
        expect(ad.decode("X(8x2)(3x3)ABCY")).to eq("X(3x3)ABC(3x3)ABCY")
      end
    end

    describe "#decodev2" do
      it "decodes a string with no markers as itself" do
        expect(ad.decodev2("TheQuickBrownFox")).to eq("TheQuickBrownFox")
      end

      it "handles multiple chars repeating" do
        expect(ad.decodev2("(3x3)XYZ")).to eq("XYZXYZXYZ")
      end

      it "handles nesting" do
        expect(ad.decodev2("X(8x2)(3x3)ABCY")).to eq("XABCABCABCABCABCABCY")
      end

      xit "handles very long strings" do
        # ad.debug!
        expect(ad.decodev2("(27x12)(20x12)(13x14)(7x10)(1x12)A").length).to eq(241920)
        expect(ad.decodev2("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN").length).to eq(445)
      end
    end

    context "validation" do
    end
  end
end
