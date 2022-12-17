require './tetris.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
    EOS
  }

  describe Advent::Tetris do
    let(:ad) { Advent::Tetris.new(input) }

    describe "#new" do
      it "inits a list of jet pulses" do
        expect(ad.jets.count).to eq(40)
        expect(ad.jets.first).to eq(:>)
      end

      it "inits a jet position" do
        expect(ad.jet_pos).to eq(0)
      end

      it "inits rock pos" do
        expect(ad.rock_pos).to eq(0)
      end

      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end
    end

    describe "#get_next_jet" do
      it "returns the current jet" do
        expect(ad.get_next_jet).to eq(:>)
      end

      it "increments the jet counter" do
        ad.get_next_jet
        expect(ad.jet_pos).to eq(1)
      end

      it "cycles back to zero" do
        40.times { ad.get_next_jet }
        expect(ad.jet_pos).to eq(0)
      end
    end

    describe "#get_next_rock" do
      it "gets a rock" do
        expect(ad.get_next_rock).to eq([[0,0],[1,0],[2,0],[3,0]])
      end

      it "increments the rock counter" do
        ad.get_next_rock
        expect(ad.rock_pos).to eq(1)
      end

      it "cycles back to zero" do
        5.times { ad.get_next_rock }
        expect(ad.rock_pos).to eq(0)
      end
    end

    # Each rock appears so that its
    # left edge is two units away from the left wall and
    # its bottom edge is three units above the highest rock
    # in the room (or the floor, if there isn't one).

    # After a rock appears,
    # it alternates between being pushed by a jet of hot gas one unit and
    # then falling one unit down.

    # If any movement would cause any part of the rock to move into the
    # walls, floor, or a stopped rock,
    # the movement instead does not occur.
    
    # If a downward movement would have caused a falling rock to move into the
    # floor or an already-fallen rock,
    # the falling rock stops where it is
    # new rock immediately begins falling.

    context "validation" do
    end
  end
end
