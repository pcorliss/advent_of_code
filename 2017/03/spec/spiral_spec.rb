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

    describe "#gen_grid" do
      it "updates a grid with values up to the input" do
        ad.gen_grid(1)
        expect(ad.grid[1,-1]).to eq(2)
      end

      it "returns the first value larger than the passed input" do
        expect(ad.gen_grid(24)).to eq(25)
      end

      it "handles large values" do
        ad.debug!
        expect(ad.gen_grid(805)).to eq(806)
        expect(ad.grid[0,2]).to eq(806)
      end
    end

    context "validation" do
    end
  end
end
