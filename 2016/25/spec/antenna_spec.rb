require './antenna.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    EOS
  }

  describe Advent::Antenna do
    let(:ad) { Advent::Antenna.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions.count).to eq(6)
        expect(ad.instructions.first).to eq([:cpy, 41, :a])
      end
      it "inits registers" do
        expect(ad.registers.count).to eq(4)
        expect(ad.registers[:a]).to eq(0)
        expect(ad.registers[:b]).to eq(0)
        expect(ad.registers[:c]).to eq(0)
        expect(ad.registers[:d]).to eq(0)
      end
    end

    describe "#interpret" do
      it "increments the pos counter" do
        ad.interpret([:cpy, 1, :a])
        expect(ad.pos).to eq(1)
      end

      it "cpy x y copies x integer into register y." do
        ad.interpret([:cpy, 1, :a])
        expect(ad.registers[:a]).to eq(1)
      end

      it "cpy x y copies x register into register y." do
        ad.interpret([:cpy, 1, :a])
        ad.interpret([:cpy, :a, :b])
        expect(ad.registers[:b]).to eq(1)
      end

      it "inc x increases the value of register x by one." do
        ad.interpret([:inc, :a])
        expect(ad.registers[:a]).to eq(1)
      end

      it "dec x decreases the value of register x by one." do
        ad.interpret([:dec, :a])
        expect(ad.registers[:a]).to eq(-1)
      end

      it "jnz x y jumps to an instruction y away forward via a positive" do
        ad.interpret([:cpy, 1, :a])
        ad.interpret([:jnz, :a, 2])
        expect(ad.pos).to eq(3)
      end

      it "jnz x y jumps to an instruction y away backwards via a negative" do
        ad.interpret([:cpy, 1, :a])
        ad.interpret([:jnz, :a, -1])
        expect(ad.pos).to eq(0)
      end

      it "jnz does nothing if x is zero" do
        ad.interpret([:jnz, :a, 2])
        expect(ad.pos).to eq(1)
      end

      it "adds registers together" do
        ad.interpret([:inc, :a])
        ad.interpret([:inc, :b])
        ad.interpret([:inc, :b])
        ad.interpret([:add, :a, :b])
        expect(ad.registers[:a]).to eq(3)
        expect(ad.registers[:b]).to eq(0)
      end

      it "mults registers together and stores in a" do
        ad.interpret([:cpy, 13, :b])
        ad.interpret([:cpy, 72, :d])
        ad.interpret([:mul, :b, :d])
        expect(ad.registers[:a]).to eq(13 * 72)
        expect(ad.registers[:b]).to eq(13)
        expect(ad.registers[:d]).to eq(0)
      end

      it "adds values to the output" do
        ad.interpret([:out, 1])
        ad.interpret([:out, 2])
        ad.interpret([:out, 3])
        expect(ad.out).to eq([1,2,3])
      end

      context "tgl toggles an instruction" do
        it "changes incs to decs" do
          ad.interpret([:tgl, 1])
          ad.interpret([:inc, :a])
          expect(ad.registers[:a]).to eq(-1)
        end

        it "changes decs to incs" do
          ad.interpret([:tgl, 1])
          ad.interpret([:dec, :a])
          expect(ad.registers[:a]).to eq(1)
        end

        it "changes jnz to cpy" do
          ad.interpret([:tgl, 1])
          ad.interpret([:jnz, 1, :a])
          expect(ad.registers[:a]).to eq(1)
        end

        it "changes cpy to jnz" do
          ad.interpret([:cpy, 1, :a])
          ad.interpret([:tgl, 1])
          ad.interpret([:cpy, :a, -2])
          expect(ad.pos).to eq(0)
        end

        it "does nothing if the instruction is outside the program" do
          ad.interpret([:tgl, 2])
          ad.interpret([:inc, :a])
          expect(ad.registers[:a]).to eq(1)
        end

        it "makes invalid instructions skipable" do
          ad.interpret([:tgl, 1])
          ad.interpret([:jnz, 1, 2])
          expect(ad.registers[2]).to be_nil
        end

        it "modifies itslef into an inc" do
          ad.interpret([:tgl, 1])
          ad.interpret([:tgl, :a])
          expect(ad.registers[:a]).to eq(1)
        end

        it "handles multiple toggles" do
          ad.interpret([:tgl, 2])
          ad.interpret([:tgl, 1])
          ad.interpret([:inc, :a])
          expect(ad.registers[:a]).to eq(1)
        end
      end
    end

    describe "#run!" do
      it "runs the code" do
        ad.run!
        expect(ad.pos).to eq(6)
      end
    end

    describe "#run!" do
      let(:input) {
        <<~EOS
        out 1
        out 2
        out 3
        out 1
        out 2
        out 3
        EOS
      }
      it "bails if the pattern doesn't match the input" do
        expect(ad.run_with_check!([1,1])).to eq(-1)
      end

      it "runs to completion if the pattern matches" do
        ad.run_with_check!([1,2,3])
        expect(ad.out).to eq([1,2,3,1,2,3])
      end
    end

    context "validation" do
      it "yields the correct registers" do
        ad.run!
        expect(ad.registers).to eq(
          a: 42, b: 0, c:0, d: 0,
        )
      end

      it "yields the correct value for toggles" do
        input = <<~EOS
        cpy 2 a
        tgl a
        tgl a
        tgl a
        cpy 1 a
        dec a
        dec a
        EOS
        ad = Advent::Antenna.new(input)
        ad.run!

        expect(ad.registers[:a]).to eq(3)
      end
    end
  end
end
