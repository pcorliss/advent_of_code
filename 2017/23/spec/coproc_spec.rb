require './coproc.rb'
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

  describe Advent::Coproc do
    let(:ad) { Advent::Coproc.new(input) }

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
      it "set X Y sets register X to the value of Y." do
        ad.run_inst(:set, :a, 99)
        expect(ad.registers[:a]).to eq(99)
      end

      it "set X Y sets register X to the value of register Y." do
        ad.run_inst(:set, :b, 99)
        ad.run_inst(:set, :a, :b)
        expect(ad.registers[:a]).to eq(99)
      end

      it "mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y." do
        ad.run_inst(:set, :a, 9)
        ad.run_inst(:mul, :a, 11)
        expect(ad.registers[:a]).to eq(99)
      end

      it "increments the position counter" do
        ad.run_inst(:set, :b, 99)
        expect(ad.pos).to eq(1)
      end

      it "sub X Y decreases register X by the value of Y." do
        ad.run_inst(:set, :a, 100)
        ad.run_inst(:sub, :a, 1)
        expect(ad.registers[:a]).to eq(99)
      end

      it "jnz X Y jumps with an offset of the value of Y" do
        ad.run_inst(:set, :a, 100)
        ad.run_inst(:jnz, :a, 2)
        expect(ad.pos).to eq(3)
      end

      it "jnz X Y does nothing value of X is zero" do
        ad.run_inst(:jnz, :a, 2)
        expect(ad.pos).to eq(1)
      end

      it "jnz X Y handles a value for X instead of a register" do
        ad.run_inst(:jnz, 1, 2)
        expect(ad.pos).to eq(2)
      end
    end

    describe "#halt?" do
      it "returns false if we still have instructions to run" do
        expect(ad.halt?).to be_falsey
      end

      # it "returns true if we have jumped off the beginning" do
      #   ad.run_inst(:set, :a, 1)
      #   ad.run_inst(:jgz, :a, -10)
      #   expect(ad.halt?).to be_truthy
      # end

      it "returns true if we have jumped off the end" do
        ad.run_inst(:set, :a, 1)
        ad.run_inst(:jnz, :a, 99)
        expect(ad.halt?).to be_truthy
      end
    end

    context "validation" do
      let(:input) {
        <<~EOS
          set a 1
          add a 2
          mul a a
          mul a a
          mul a a
        EOS
      }
      it "records the number of times the mul instruction is invoked" do
        # ad.debug!
        ad.run!
        expect(ad.inst_count[:mul]).to eq(3)
      end
    end
  end
end
