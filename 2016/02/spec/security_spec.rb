require './security.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ULL
    RRDDD
    LURDL
    UUUUD
    EOS
  }

  describe Advent::Security do
    let(:ad) { Advent::Security.new(input) }

    describe "#new" do
      it "inits a list of instructions" do
        expect(ad.inst).to eq([
          %w(U L L),
          %w(R R D D D),
          %w(L U R D L),
          %w(U U U U D),
        ])
      end

      it "inits a keypad grid" do
        expect(ad.keypad).to be_a(Grid)
        expect(ad.keypad[0,0]).to eq(1)
        expect(ad.keypad[1,0]).to eq(2)
        expect(ad.keypad[2,0]).to eq(3)
        expect(ad.keypad[1,1]).to eq(5)
        expect(ad.keypad[2,2]).to eq(9)
      end
    end

    describe "#run_inst" do
      let(:start) { [1,1] } # Start on position 5
      it "runs a simple instruction and returns the new position" do
        instructions = %w( U L )
        expect(ad.run_inst(start, instructions)).to eq([0,0])
      end

      it "doesn't go beyond boundaries" do
        instructions = %w( U L L L L )
        expect(ad.run_inst(start, instructions)).to eq([0,0])
      end

      it "handles boundaries on alternate keypads" do
        keypad = [
          nil, nil, 1, nil, nil,
          nil, 2, 3, 4, nil,
          5, 6, 7, 8, 9,
          nil, 'A', 'B', 'C', nil,
          nil, nil, 'D', nil, nil,
        ]
        ad.keypad = Grid.new(keypad, 5)
        # start position is on the 2
        instructions = %w( U L )
        expect(ad.run_inst(start, instructions)).to eq(start)
      end
    end

    describe "#run_all_instructions" do
      let(:start) { [1,1] } # Start on position 5
      it "runs all instructions and returns a collection of positions" do
        expect(ad.run_all_instructions(start)).to eq([
          [0,0],
          [2,2],
          [1,2],
          [1,1],
        ])
      end

      it "handles part 2 keypad" do
        keypad = [
          nil, nil, 1, nil, nil,
          nil, 2, 3, 4, nil,
          5, 6, 7, 8, 9,
          nil, 'A', 'B', 'C', nil,
          nil, nil, 'D', nil, nil,
        ]
        ad.keypad = Grid.new(keypad, 5)
        start = [0, 2] # still start at 5
        expect(ad.run_all_instructions(start)).to eq([
          [0,2],
          [2,4],
          [2,3],
          [2,1],
        ])
      end
    end

    describe "#map_code" do
      it "takes a collection of positions and returns the corresponding keypad loc" do
        positions = [
          [0,0],
          [2,2],
          [1,2],
          [1,1],
        ]
        expect(ad.map_code(positions)).to eq([1, 9, 8, 5])
      end

      it "handles alternate keypads" do
        keypad = [
          nil, nil, 1, nil, nil,
          nil, 2, 3, 4, nil,
          5, 6, 7, 8, 9,
          nil, 'A', 'B', 'C', nil,
          nil, nil, 'D', nil, nil,
        ]
        positions = [
          [0,2],
          [2,4],
          [2,3],
          [2,1],
        ]
        ad.keypad = Grid.new(keypad, 5)
        expect(ad.map_code(positions)).to eq([5, 'D', 'B', 3])
      end
    end

    context "validation" do
    end
  end
end
