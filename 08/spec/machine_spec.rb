require '../machine.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
    EOS
  }

  describe Advent::Machine do
    let(:ad) { Advent::Machine.new(input) }

    describe "#new" do
      it "loads a list into an array" do
        expect(ad.inst.first).to eq(["nop", 0])
      end
    end

    context "validation" do
      it "returns the acc value before infinite looping" do
        expect(ad.val_before_loop).to eq(5)
      end
      it "returns the acc value when not infinite looping" do
        expect(ad.fix_jmp).to eq(8)
      end
    end
  end
end
