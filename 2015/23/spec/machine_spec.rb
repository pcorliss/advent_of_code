require './machine.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    inc a
    jio a, +2
    tpl a
    inc a
    jmp +2
    EOS
  }

  describe Advent::Machine do
    let(:ad) { Advent::Machine.new(input) }

    describe "#new" do
      it "it inits instructions" do
        expect(ad.instructions).to eq([
          [:inc, :a, 0],
          [:jio, :a, 2],
          [:tpl, :a, 0],
          [:inc, :a, 0],
          [:jmp,  2, 0],
        ])
      end
    end

    describe "#run" do
      it "hlf r sets register r to half its current value, then continues with the next instruction." do
        ad.instructions = [
          [:inc, :a, 0],
          [:inc, :a, 0],
          [:inc, :b, 0],
          [:hlf, :a, 0],
          [:hlf, :b, 0],
        ]
        expect(ad.run!).to eq([1,0])
      end

      it "tpl r sets register r to triple its current value, then continues with the next instruction." do
        ad.instructions = [
          [:inc, :a, 0],
          [:inc, :a, 0],
          [:inc, :b, 0],
          [:tpl, :a, 0],
          [:tpl, :b, 0],
        ]
        expect(ad.run!).to eq([6,3])
      end

      it "inc r increments register r, adding 1 to it, then continues with the next instruction." do
        ad.instructions = [
          [:inc, :a, 0],
          [:inc, :a, 0],
          [:inc, :b, 0],
        ]
        expect(ad.run!).to eq([2,1])
      end

      it "jmp offset is a jump; it continues with the instruction offset away relative to itself." do
        ad.instructions = [
          [:inc, :a, 0],
          [:jmp,  2, 0],
          [:inc, :a, 0],
          [:inc, :b, 0],
        ]
        expect(ad.run!).to eq([1,1])
      end

      it "jie r, offset is like jmp, but only jumps if register r is even (\"jump if even\")." do
        ad.instructions = [
          [:inc, :a, 0],
          [:inc, :a, 0],
          [:jie, :a, 2],
          [:inc, :b, 0],
          [:inc, :b, 0],
        ]
        expect(ad.run!).to eq([2,1])
      end

      it "ignores jie if register is odd" do
        ad.instructions = [
          [:inc, :a, 0],
          [:jie, :a, 2],
          [:inc, :a, 0],
          [:inc, :b, 0],
        ]
        expect(ad.run!).to eq([2,1])
      end

      it "jio r, offset is like jmp, but only jumps if register r is 1 (\"jump if one\", not odd)." do
        ad.instructions = [
          [:inc, :a, 0],
          [:jio, :a, 2],
          [:inc, :a, 0],
          [:inc, :b, 0],
        ]
        expect(ad.run!).to eq([1,1])
      end

      it "ignores jio if register is not one" do
        ad.instructions = [
          [:inc, :a, 0],
          [:inc, :a, 0],
          [:inc, :a, 0],
          [:jio, :a, 2],
          [:inc, :b, 0],
          [:inc, :b, 0],
        ]
        expect(ad.run!).to eq([3,2])
      end
    end

    context "validation" do
    end
  end
end
