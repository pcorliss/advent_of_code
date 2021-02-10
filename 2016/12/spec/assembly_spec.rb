require './assembly.rb'
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

  describe Advent::Assembly do
    let(:ad) { Advent::Assembly.new(input) }

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
    end

    describe "#run!" do
      it "runs the code" do
        ad.run!
        expect(ad.pos).to eq(6)
      end
    end

    context "validation" do
      it "yields the correct registers" do
        ad.run!
        expect(ad.registers).to eq(
          a: 42, b: 0, c:0, d: 0,
        )
      end
    end
  end
end
