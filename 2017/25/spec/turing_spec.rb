require './turing.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
    EOS
  }

  describe Advent::Turing do
    let(:ad) { Advent::Turing.new(input) }

    describe "#new" do
      it "inits a tape" do
        expect(ad.tape).to be_a(Hash)
      end

      it "inits a cursor" do
        expect(ad.cursor).to eq(0)
      end

      it "inits instructions" do
        expect(ad.state).to eq('A')
        expect(ad.diag).to eq(6)
        expect(ad.instructions['A'][0]).to eq([
          [:write, 1],
          [:move, 1],
          [:state, 'B'],
        ])
      end
    end

    describe "#run!" do
      it "runs until the passed number" do
        ad.run!(1)
        expect(ad.cursor).to eq(1)
        expect(ad.tape).to eq({0 => 1})
        expect(ad.state).to eq('B')
      end

      it "runs until the diag counter is reached" do
        ad.run!
        expect(ad.cursor).to eq(0)
        expect(ad.tape).to eq(
           0 => 0,
           1 => 1,
          -1 => 1,
          -2 => 1,
        )
        expect(ad.state).to eq('A')
      end
    end

    describe "#checksum" do
      it "returns the number of 1's on the tape" do
        expect(ad.checksum).to eq(0)
        ad.run!
        expect(ad.checksum).to eq(3)
      end
    end


    context "validation" do
    end
  end
end
