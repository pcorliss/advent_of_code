require './duet.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
    EOS
  }

  describe Advent::Duet do
    let(:ad) { Advent::Duet.new(input) }

    describe "#new" do
      it "inits a list of instructions" do
        expect(ad.instructions.count).to eq(10)
        expect(ad.instructions.first).to eq([:set, :a, 1])
        expect(ad.instructions[4]).to eq([:snd, :a])
      end

      it "inits a position" do
        expect(ad.pos).to eq(0)
      end

      it "inits registers with a default val of 0" do
        expect(ad.registers[:foo]).to eq(0)
      end
    end

    describe "#run_inst" do
      it "snd X plays a sound with a frequency equal to the value of X." do
        ad.registers[:a] = 99
        ad.run_inst(:snd, :a)
        expect(ad.last_sound).to eq(99)
      end

      it "set X Y sets register X to the value of Y." do
        ad.run_inst(:set, :a, 99)
        expect(ad.registers[:a]).to eq(99)
      end

      it "set X Y sets register X to the value of register Y." do
        ad.run_inst(:set, :b, 99)
        ad.run_inst(:set, :a, :b)
        expect(ad.registers[:a]).to eq(99)
      end

      it "add X Y increases register X by the value of Y." do
        ad.run_inst(:add, :a, 98)
        ad.run_inst(:add, :a, 1)
        expect(ad.registers[:a]).to eq(99)
      end

      it "mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y." do
        ad.run_inst(:set, :a, 9)
        ad.run_inst(:mul, :a, 11)
        expect(ad.registers[:a]).to eq(99)
      end

      it "mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y)." do
        ad.run_inst(:set, :a, 99)
        ad.run_inst(:mod, :a, 30)
        expect(ad.registers[:a]).to eq(9)
      end

      it "rcv X recovers the frequency of the last sound played" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:set, :b, 99)
        ad.run_inst(:snd, :b)
        ad.run_inst(:rcv, :a)
        expect(ad.registers[:a]).to eq(99)
      end

      it "rcv X , If it is zero, the command does nothing." do
        ad.run_inst(:set, :b, 99)
        ad.run_inst(:snd, :b)
        ad.run_inst(:rcv, :a)
        expect(ad.registers[:a]).to eq(0)
      end

      it "increments the position counter" do
        ad.run_inst(:set, :b, 99)
        expect(ad.pos).to eq(1)
      end

      it "jgz X Y jumps with an offset of the value of Y if X is greater than zero" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:jgz, :a, 2)
        expect(ad.pos).to eq(3)
      end

      it "jgz does nothing if the value of X is equal to or lesser than zero" do
        ad.run_inst(:jgz, :a, 2)
        expect(ad.pos).to eq(1)
      end

      it "jgz handles negative jumps" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:jgz, :a, -1)
        expect(ad.pos).to eq(0)
      end
    end

    describe "#halt?" do
      it "returns false if we still have instructions to run" do
        expect(ad.halt?).to be_falsey
      end

      it "returns true if we have jumped off the beginning" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:jgz, :a, -10)
        expect(ad.halt?).to be_truthy
      end

      it "returns true if we have jumped off the end" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:jgz, :a, 99)
        expect(ad.halt?).to be_truthy
      end

      it "returns true if we have hit a rcv instruction and it was tripped" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:set, :b, 99)
        ad.run_inst(:snd, :b)
        ad.run_inst(:rcv, :a)
        expect(ad.halt?).to be_truthy
      end
    end

    describe "#run!" do
      it "does stuff until rcv is hit" do
        ad.debug!
        ad.run!
        expect(ad.registers[:a]).to eq(4)
        expect(ad.last_sound).to eq(4)
      end
    end

    context "validation" do
    end
  end
end
