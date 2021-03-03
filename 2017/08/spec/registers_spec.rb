require './registers.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    EOS
  }

  describe Advent::Registers do
    let(:ad) { Advent::Registers.new(input) }

    describe "#new" do
      it "inits a list of instructions" do
        expect(ad.instructions.count).to eq(4)
        expect(ad.instructions.first).to eq([:b, :inc, 5, :if, :a, :>, 1])
      end

      it "inits registers seen in instructions" do
        expect(ad.registers).to eq({
          a: 0,
          b: 0,
          c: 0,
        })
      end
    end

    describe "#run_inst" do
      it "increments registers if the condition is met" do
        ad.run_inst([:a, :inc, 1, :if, :a, :==, 0])
        expect(ad.registers[:a]).to eq(1)
      end

      it "decrements registers if the condition is met" do
        ad.run_inst([:a, :dec, 1, :if, :a, :==, 0])
        expect(ad.registers[:a]).to eq(-1)
      end

      it "does nothing if the condition is not met" do
        ad.run_inst([:a, :dec, 1, :if, :a, :==, 1])
        expect(ad.registers[:a]).to eq(0)
      end
    end

    describe "#run!" do
      it "runs all instructions" do
        ad.run!
        expect(ad.registers).to eq({
          a: 1,
          b: 0,
          c: -10,
        })
      end

      it "returns the max value held at any point" do
        expect(ad.run!).to eq(10)
      end
    end
    context "validation" do
    end
  end
end
