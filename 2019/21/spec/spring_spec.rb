require './spring.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  # it can only remember at most 15 springscript instructions.
  # T, the temporary value register,
  # J, the jump register.
  # If the jump register is true at the end of the springscript program, the springdroid will try to jump.
  # Both of these registers start with the value false.
  # Your springdroid can detect ground at four distances: one tile away (A), two tiles away (B), three tiles away (C), and four tiles away (D).
  # If there is ground at the given distance, the register will be true; if there is a hole, the register will be false.
  # AND X Y sets Y to true if both X and Y are true; otherwise, it sets Y to false.
  # OR X Y sets Y to true if at least one of X or Y is true; otherwise, it sets Y to false.
  # NOT X Y sets Y to true if X is false; otherwise, it sets Y to false.
  # the second argument (Y) needs to be a writable register (either T or J).
  # The first argument (X) can be any register (including A, B, C, or D).
  # It will begin by displaying a prompt; then, input the desired instructions one per line.
  # End each line with a newline (ASCII code 10).
  # When you have finished entering your program, provide the command WALK followed by a newline to instruct the springdroid to begin surveying the hull.

  describe Advent::Spring do
    let(:ad) { Advent::Spring.new(input) }
    let(:spring_script) {
      <<~EOS
        NOT A J
        NOT B T
        AND T J
        NOT C T
        AND T J
        AND D J
      EOS
    }

    describe "#new" do
      it "inits a program" do
        expect(ad.program).to be_a(Advent::IntCode)
      end
    end

    describe "#write_program" do
      it "takes a spring script and sets the input" do
        ad.write_program(spring_script)
        expect(ad.program.inputs).to start_with([78, 79, 84, 32, 65, 32, 74, 10])
        expect(ad.program.inputs).to end_with([65, 78, 68, 32, 68, 32, 74, 10, 87, 65, 76, 75, 10])
      end
    end

    describe "#run_and_output" do
      it "runs the program and prints the output" do
        ad.write_program(spring_script)
        expect(ad.run_and_output).to be_a(String)
      end
    end

    # '##.##'
    # '##..#.#'
    # '##...##'
    #
    # if A is False Jump # Immediate jump
    # NOT A J
    # if b is false jump
    # NOT B T
    # OR T J
    # if c is false jump
    # NOT C T
    # OR T J
    # If D is false don't jump because we won't be able to land
    # AND D J
    #
    context "validation" do
      it "makes it across the gap" do
        spring_script = <<~EOS
        NOT A J
        NOT B T
        OR T J
        NOT C T
        OR T J
        AND D J
        EOS
        ad.write_program(spring_script)
        out = ad.run_and_output
        puts out
        expect(out).to_not include("Didn't make it across")
        expect(out).to_not include("expected something like AND, OR, or NOT")
        expect(out).to end_with("19354928")
      end
    end
  end
end
