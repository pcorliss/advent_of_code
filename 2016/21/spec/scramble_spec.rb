require './scramble.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      swap position 4 with position 0
      swap letter d with letter b
      reverse positions 0 through 4
      rotate left 1 step
      move position 1 to position 4
      move position 3 to position 0
      rotate based on position of letter b
      rotate based on position of letter d
    EOS
  }

  describe Advent::Scramble do
    let(:ad) { Advent::Scramble.new(input) }

    describe "#new" do
      it "inits the pw" do
        expect(ad.rules.count).to eq(8)
        expect(ad.rules).to eq([
          [:swap_position, 4, 0],
          [:swap_letter, 'd', 'b'],
          [:reverse_positions, 0, 4],
          [:rotate_left, 1],
          [:move_position, 1, 4],
          [:move_position, 3, 0],
          [:rotate_based, 'b'],
          [:rotate_based, 'd'],
        ])
      end
    end

    describe "#scramble" do
      it "swaps positions" do
        ad = Advent::Scramble.new("swap position 4 with position 0")
        expect(ad.scramble('abcde')).to eq('ebcda')
      end

      it "swaps letters" do
        ad = Advent::Scramble.new("swap letter d with letter b")
        expect(ad.scramble('ebcda')).to eq('edcba')
      end

      it "reverses entire strings" do
        ad = Advent::Scramble.new("reverse positions 0 through 4")
        expect(ad.scramble('edcba')).to eq('abcde')
      end

      it "reverses positions" do
        ad = Advent::Scramble.new("reverse positions 1 through 6")
        expect(ad.scramble('abcfdhge')).to eq('aghdfcbe')
      end

      it "rotate left" do
        ad = Advent::Scramble.new("rotate left 1 step")
        expect(ad.scramble('abcde')).to eq('bcdea')
      end

      it "rotate right" do
        ad = Advent::Scramble.new("rotate right 1 step")
        expect(ad.scramble('abcde')).to eq('eabcd')
      end

      it "moves positional elements forward properly" do
        ad = Advent::Scramble.new("move position 1 to position 4")
        expect(ad.scramble('bcdea')).to eq('bdeac')
      end

      it "moves positional elements backwards" do
        ad = Advent::Scramble.new("move position 3 to position 0")
        expect(ad.scramble('bdeac')).to eq('abdec')
      end

      it "rotates based on position" do
        ad = Advent::Scramble.new("rotate based on position of letter b")
        expect(ad.scramble('abdec')).to eq('ecabd')
      end

      it "rotates an additional time if the index >= 4" do
        ad = Advent::Scramble.new("rotate based on position of letter d")
        expect(ad.scramble('ecabd')).to eq('decab')
      end

      it "returns the scrambled password" do
        expect(ad.scramble('abcde')).to eq('decab')
      end
    end

    context "validation" do
    end
  end
end
