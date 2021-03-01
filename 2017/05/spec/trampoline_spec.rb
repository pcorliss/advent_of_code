require './trampoline.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    0
    3
    0
    1
    -3
    EOS
  }

  describe Advent::Trampoline do
    let(:ad) { Advent::Trampoline.new(input) }

    describe "#new" do
      it "inits a list of jumps" do
        expect(ad.jumps.count).to eq(5)
        expect(ad.jumps.first).to eq(0)
      end

      it "inits a position" do
        expect(ad.pos).to eq(0)
      end
    end

    describe "#step!" do
      it "doesn't increment the position if the current step is zero" do
        ad.step!
        expect(ad.pos).to eq(0)
      end

      it "increments the positiion by the value of the current non-zero step" do
        ad.jumps[0] = 2
        ad.step!
        expect(ad.pos).to eq(2)
      end

      it "increments the instruction" do
        ad.step!
        expect(ad.jumps.first).to eq(1)
      end

      context "part two" do
        it "decrements the step if it was 3 or more" do
          3.times { ad.step!(true) }
          expect(ad.jumps[1]).to eq(2)
        end
      end
    end

    describe "#exit?" do
      it "returns false if the exit hasn't been reached yet" do
        expect(ad.exit?).to be_falsey
      end

      it "returns true if the exit has been reached" do
        5.times { ad.step! }
        expect(ad.exit?).to be_truthy
      end
    end

    describe "#run!" do
      it "returns the number of steps until the exit is reached" do
        expect(ad.run!).to eq(5)
      end

      context "part two" do
        it "returns the number of steps until the exit is reached" do
          expect(ad.run!(true)).to eq(10)
        end
      end
    end

    context "validation" do
      it "has the correct state after completion" do
        ad.run!
        expect(ad.jumps).to eq([2,5,0,1,-2])
      end

      context "part two" do
        it "returns the number of steps until the exit is reached" do
        ad.run!(true)
        expect(ad.jumps).to eq([2,3,2,3,-1])
        end
      end
    end
  end
end
