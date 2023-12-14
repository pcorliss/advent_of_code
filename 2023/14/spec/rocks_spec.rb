require './rocks.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    EOS
  }

  describe Advent::Rocks do
    let(:ad) { Advent::Rocks.new(input) }

    describe "#new" do
      it "inits a grid of rocks" do
        expect(ad.grid[0,0]).to eq('O')
        expect(ad.grid[1,0]).to eq('.')
        expect(ad.grid[0,1]).to eq('O')
      end
    end

    describe "#tilt!" do
      let(:expected_tilt) {
        <<~EOS
        OOOO.#.O..
        OO..#....#
        OO..O##..O
        O..#.OO...
        ........#.
        ..#....#.#
        ..O..#.O.O
        ..O.......
        #....###..
        #....#....
        EOS
      }
      it "tilts the rocks northwards" do
        ad.tilt!
        expect(ad.grid.render).to eq(expected_tilt.chomp)
      end
    end

    describe "#total_load" do
      it "returns the total load" do
        ad.tilt!
        expect(ad.total_load).to eq(136)
      end
    end

    context "validation" do
    end
  end
end
