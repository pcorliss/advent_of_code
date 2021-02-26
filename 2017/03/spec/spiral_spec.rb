require './spiral.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    1024
    EOS
  }

  describe Advent::Spiral do
    let(:ad) { Advent::Spiral.new(input) }

    describe "#new" do
      it "inits the square" do
        expect(ad.square).to eq(1024)
      end
    end

    describe "#find_shell" do
      {
        1 => 0,
        2 => 1,
        3 => 1,
        4 => 1,
        7 => 1,
        9 => 1,
        10 => 2,
        21 => 2,
        25 => 2,
        26 => 3,
      }.each do |sq, shell|
        it "returns the #{shell} shell of a given #{sq} square" do
          expect(ad.find_shell(sq)).to eq(shell)
        end
      end
    end

    describe "#get_pos" do
      {
        1 => [0,0],
        2 => [1,0],
        3 => [1,1],
        4 => [0,1],
        5 => [-1,1],
        6 => [-1,0],
        7 => [-1,-1],
        8 => [0,-1],
        9 => [1,-1],
        10 => [2,-1],
        21 => [-2,-2],
        25 => [2, -2],
        26 => [3, -2],
        1024 => [-15,16],
        277678 => [212, -263],
      }.each do |square, expected|
        it "returns the coordinates of a given square" do
          # ad.debug!
          expect(ad.get_pos(square)).to eq(expected)
        end
      end
    end

    context "validation" do
    end
  end
end
