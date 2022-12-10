require './signals.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    noop
    addx 3
    addx -5
    EOS
  }
  let(:larger) { File.read('./spec/larger_input.txt') }

  describe Advent::Signals do
    let(:ad) { Advent::Signals.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions.count).to eq(3)
        expect(ad.instructions[0]).to eq([:noop])
        expect(ad.instructions[2]).to eq([:addx, -5])
      end

      it "instantiates X" do
        expect(ad.x).to eq(1)
      end

      it "instantiates cycle counter" do
        expect(ad.cycle).to eq(0)
      end

      # Points to current instruction
      it "instantiates a intruction position" do
        expect(ad.instruction_position).to eq(0)
      end

      # For instructions that take multiple cycles
      it "instantiates an instruction counter" do
        expect(ad.instruction_counter).to eq(0)
      end
    end

    describe "#run_cycle!" do
      # noop takes one cycle to complete. It has no other effect.
      describe "noop" do
        before do
          ad.run_cycle!
        end

        it "takes one cycle to complete" do
          expect(ad.cycle).to eq(1)
        end

        it "does nothing" do
          expect(ad.x).to eq(1)
        end

        it "increases the instruction position" do
          expect(ad.instruction_position).to eq(1)
        end
      end

      # addx V takes two cycles to complete.
      # After two cycles, the X register is increased by the value V. (V can be negative.)
      describe "#addx" do
        context "after the first cycle" do
          before do
            2.times { ad.run_cycle! }
          end

          it "increases the instruction counter but not the position" do
            expect(ad.instruction_counter).to eq(1)
            expect(ad.instruction_position).to eq(1)
          end

          it "doesn't change x" do
            expect(ad.x).to eq(1)
          end
        end

        context "after the second cycle" do
          before do
            3.times { ad.run_cycle! }
          end

          it "adds the value" do
            expect(ad.x).to eq(4)
          end

          it "resets the instruction counter and increases the instruction position" do
            expect(ad.instruction_counter).to eq(0)
            expect(ad.instruction_position).to eq(2)
          end
        end
      end
    end

    describe "#signal_strength" do
      let(:ad) { Advent::Signals.new(larger) }

      [
        [20 , 21,  420],
        [60 , 19, 1140],
        [100, 18, 1800],
        [140, 21, 2940],
        [180, 16, 2880],
        [220, 18, 3960],
      ].each do |cycles, x, signal|
        it "returns the #{signal} signal strength for the #{cycles} cycle where X is #{x}" do
          # Something about "during the cycle" is important here
          # I think we want the strength before the cycle executes
          (cycles-1).times { |i|
            ad.run_cycle!
          }
          expect(ad.x).to eq(x)
          expect(ad.signal_strength).to eq(signal)
        end
      end
    end

    describe "#interesting_signals" do
      let(:ad) { Advent::Signals.new(larger) }

      it "returns the interesting signals" do
        expected = [420, 1140, 1800, 2940, 2880, 3960,]
        interesting = ad.interesting_signals
        expect(interesting).to eq(expected)
        expect(interesting.sum).to eq(13140)
      end
    end

    context "validation" do
    end
  end
end
