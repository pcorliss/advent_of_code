require './monkey.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
    EOS
  }

  describe Advent::Monkey do
    let(:ad) { Advent::Monkey.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions[:root]).to eq([:pppw, :+, :sjmn])
      end

      it "loads instructions with digits" do
        expect(ad.instructions[:sllz]).to eq([4])
      end
    end

    describe "#lookup" do
      it "returns digits at the root" do
        expect(ad.lookup(:hmdt)).to eq(32)
      end

      it "returns items with math and single nesting" do
        expect(ad.lookup(:drzm)).to eq(30) 
      end

      it "returns multiple nested items" do
        expect(ad.lookup(:root)).to eq(152)
      end
    end

    context "validation" do
    end
  end
end
