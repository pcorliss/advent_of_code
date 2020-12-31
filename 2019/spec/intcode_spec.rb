require 'rspec'
require 'pry'
require_relative '../lib/intcode.rb'

describe Advent do
  describe Advent::IntCode do
    let(:input) {
      <<~EOS
      1,9,10,3,2,3,11,0,99,30,40,50
      EOS
    }

    let(:ad) { Advent::IntCode.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions).to eq([1,9,10,3,2,3,11,0,99,30,40,50])
      end
    end

    describe "#run!" do
      it "executes an addition instruction" do
        ad.run!
        expect(ad.instructions[3]).to eq(70)
      end

      it "executes a multiplication instruction" do
        ad.run!
        expect(ad.instructions[0]).to eq(3500)
      end

      context "parameter modes" do
        # ABCDE
        # DE - two digit opcode
        # C - Mode of 1st param
        # B - Mode of 2nd param
        # A - Mode of 3rd param - Parameters that an instruction writes to will never be in immediate mode.
        #
        # 2 == relative mode
        # 1 == immediate mode
        # 0 == position mode

        {
              "1,5,6,7,99,8,9,0" => [          1,5,6,7,99,8,9,17],
             "01,5,6,7,99,8,9,0" => [          1,5,6,7,99,8,9,17],
            "001,5,6,7,99,8,9,0" => [          1,5,6,7,99,8,9,17],
           "0001,5,6,7,99,8,9,0" => [          1,5,6,7,99,8,9,17],
          "00001,5,6,7,99,8,9,0" => [          1,5,6,7,99,8,9,17],
          "00101,5,6,7,99,8,9,0" => [        101,5,6,7,99,8,9,14],
          "01001,5,6,7,99,8,9,0" => [       1001,5,6,7,99,8,9,14],
          "01101,5,6,7,99,8,9,0" => [       1101,5,6,7,99,8,9,11],
          "00201,5,6,7,99,8,9,0" => [        201,5,6,7,99,8,9,17],
          "02001,5,6,7,99,8,9,0" => [       2001,5,6,7,99,8,9,17],
          "02201,5,6,7,99,8,9,0" => [       2201,5,6,7,99,8,9,17], # No Relative Mode Set - behaves as positional
          "20201,5,6,7,99,8,9,0" => [      20201,5,6,7,99,8,9,17],
          "22001,5,6,7,99,8,9,0" => [      22001,5,6,7,99,8,9,17],
          "22201,5,6,7,99,8,9,0" => [      22201,5,6,7,99,8,9,17], # No Relative Mode Set - behaves as positional
    "109,2,20201,5,8,7,99,8,9,0" => [109,2,20201,5,8,7,99,8,9,17],
    "109,2,22001,7,6,7,99,8,9,0" => [109,2,22001,7,6,7,99,8,9,17],
    "109,2,22201,5,6,7,99,8,9,0" => [109,2,22201,5,6,7,99,8,9,17],
              "2,5,6,7,99,8,9,0" => [          2,5,6,7,99,8,9,72],
             "02,5,6,7,99,8,9,0" => [          2,5,6,7,99,8,9,72],
            "002,5,6,7,99,8,9,0" => [          2,5,6,7,99,8,9,72],
           "0002,5,6,7,99,8,9,0" => [          2,5,6,7,99,8,9,72],
          "00002,5,6,7,99,8,9,0" => [          2,5,6,7,99,8,9,72],
          "00102,5,6,7,99,8,9,0" => [        102,5,6,7,99,8,9,45],
          "01002,5,6,7,99,8,9,0" => [       1002,5,6,7,99,8,9,48],
          "01102,5,6,7,99,8,9,0" => [       1102,5,6,7,99,8,9,30],
        }.each do |input, expected|
          it "takes an input of #{input} and results in #{expected}" do
            ad = Advent::IntCode.new(input)
            ad.run!
            expect(ad.instructions).to eq(expected)
          end
        end

        it "increases the relative base each time it's called" do
          input = "109,1,109,3,21101,1,2,7,4,11,99,0"
          ad = Advent::IntCode.new(input)
          ad.run!
          expect(ad.output).to eq(3)
        end
      end

      context "inputs" do
        it "sets the input" do
          input = "3,3,99,0"
          ad = Advent::IntCode.new(input)
          expect(ad.instructions.last).to eq(0)
          ad.program_input = 7
          ad.run!
          expect(ad.instructions.last).to eq(7)
        end

        it "takes multiple inputs" do
          input = "3,5,3,6,99,0,0"
          ad = Advent::IntCode.new(input)
          expect(ad.instructions[-1]).to eq(0)
          expect(ad.instructions[-2]).to eq(0)
          ad.inputs << 7
          ad.inputs << 9
          ad.run!
          expect(ad.instructions[-2]).to eq(7)
          expect(ad.instructions[-1]).to eq(9)
        end

        it "pauses if waiting on input" do
          input = "3,5,3,5,99,0"
          ad = Advent::IntCode.new(input)
          ad.inputs << 7
          ad.run!
          expect(ad.instructions.last).to eq(7)
          expect(ad.pos).to eq(2)
          expect(ad.inputs).to be_empty
          ad.inputs << 9
          ad.run!
          expect(ad.instructions.last).to eq(9)
        end
      end

      describe "#paused?" do
        it "distringuishes between paused and halted" do
          input = "3,5,3,5,99,0"
          ad = Advent::IntCode.new(input)
          ad.inputs << 7
          ad.run!
          expect(ad.paused?).to be_truthy
          expect(ad.halted?).to be_falsey
          ad.inputs << 9
          ad.run!
          expect(ad.halted?).to be_truthy
          expect(ad.paused?).to be_falsey
        end
      end

      context "outputs" do
        it "returns the output" do
          input = "4,3,99,0"
          ad = Advent::IntCode.new(input)
          ad.run!
          expect(ad.output).to eq(0)
        end

        it "stores the output, not the target" do
          input = "4,7,1101,1,1,7,99,0"
          ad = Advent::IntCode.new(input)
          ad.run!
          expect(ad.output).to eq(0)
        end
      end

      # Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      context "jump if true" do
        let(:input) { "3,3,1105,-1,9,1101,0,0,12,4,12,99,1" }
        it "jumps if true" do
          ad = Advent::IntCode.new(input)
          ad.program_input = 1
          ad.run!
          expect(ad.output).to eq(1)
        end

        it "does nothing if false" do
          ad = Advent::IntCode.new(input)
          ad.program_input = 0
          ad.run!
          expect(ad.output).to eq(0)
        end
      end

      #     Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      context "jump if false" do
        let(:input) { "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9" }
        it "jumps if false" do
          ad = Advent::IntCode.new(input)
          ad.program_input = 1
          ad.run!
          expect(ad.output).to eq(1)
        end

        it "does nothing if true" do
          ad = Advent::IntCode.new(input)
          ad.program_input = 0
          ad.run!
          expect(ad.output).to eq(0)
        end
      end

      #     Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      context "less_than" do
        [
          "3,9,7,9,10,9,4,9,99,-1,8", # - Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
          "3,3,1107,-1,8,3,4,3,99", # - Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
        ].each do |input|
          it "sets the output to 1 if the input is less than 8" do
            ad = Advent::IntCode.new(input)
            ad.program_input = 7
            ad.run!
            expect(ad.output).to eq(1)
          end

          it "sets the output to 0 if the input is equal to 8" do
            ad = Advent::IntCode.new(input)
            ad.program_input = 8
            ad.run!
            expect(ad.output).to eq(0)
          end

          it "sets the output to 0 if the input is greater than 8" do
            ad = Advent::IntCode.new(input)
            ad.program_input = 9
            ad.run!
            expect(ad.output).to eq(0)
          end
        end
      end

      #     Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      context "equals" do
        [
          "3,9,8,9,10,9,4,9,99,-1,8", # - Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
          "3,3,1108,-1,8,3,4,3,99", # - Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
        ].each do |input|
          it "sets the output to 1 if the input is equivalent to 8" do
            ad = Advent::IntCode.new(input)
            ad.program_input = 8
            ad.run!
            expect(ad.output).to eq(1)
          end

          it "sets the output to 0 if the input is not equivalent to 8" do
            ad = Advent::IntCode.new(input)
            ad.program_input = 7
            ad.run!
            expect(ad.output).to eq(0)
          end
        end
      end
    end

    context "validation" do
      {
        "1,0,0,0,99" => [2,0,0,0,99],
        "2,3,0,3,99" => [2,3,0,6,99],
        "2,4,4,5,99,0" => [2,4,4,5,99,9801],
        "1,1,1,4,99,5,6,0,99" => [30,1,1,4,2,5,6,0,99],
      }.each do |input, expected|
        it "takes an input of #{input} and results in #{expected}" do
          ad = Advent::IntCode.new(input)
          ad.run!
          expect(ad.instructions).to eq(expected)
        end
      end

      context "jumps and comparisons" do
        let(:input) { "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99" }

        it "will output 999 if the input value is below 8" do
          ad.program_input = 7
          ad.run!
          expect(ad.output).to eq(999)
        end

        it "will output 1000 if the input value is equal to 8" do
          ad.program_input = 8
          ad.run!
          expect(ad.output).to eq(1000)
        end

        it "will output 1001 if the input value is greater than 8" do
          ad.program_input = 9
          ad.run!
          expect(ad.output).to eq(1001)
        end
      end

      it "takes no input and produces a copy of itself" do
        input = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
        ad = Advent::IntCode.new(input)
        # ad.debug!
        ad.run!
        expect(ad.full_output.map(&:to_s).join(",")).to eq(input)
      end

      it "should output a 16-digit number." do
        input = "1102,34915192,34915192,7,4,7,99,0"
        ad = Advent::IntCode.new(input)
        ad.run!
        expect(ad.output.to_s.length).to eq(16)
      end

      it "should output the large number in the middle." do
        input = "104,1125899906842624,99"
        ad = Advent::IntCode.new(input)
        ad.run!
        expect(ad.output).to eq(1125899906842624)
      end
    end
  end
end
