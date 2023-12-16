require './beam.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~'EOS'
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    EOS
  }

  describe Advent::Beam do
    let(:ad) { Advent::Beam.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[0,0]).to eq('.')
        expect(ad.grid[1,0]).to eq('|')
        expect(ad.grid.width).to eq(10)
        expect(ad.grid.height).to eq(10)
      end
    end

    describe "#render_grid" do
      let(:beam_map) {
        <<~'EOS'
        >|<<<\....
        |v-.\^....
        .v...|->>>
        .v...v^.|.
        .v...v^...
        .v...v^..\
        .v../2\\..
        <->-/vv|..
        .|<<<2-|.\
        .v//.|.v..
        EOS
      }

      it "returns a grid with the beam path rendered" do
        ad.energize
        expect(ad.render_grid).to eq(beam_map.chomp)
      end
    end

    describe "#render_energized" do
      let(:energized) {
        <<~'EOS'
        ######....
        .#...#....
        .#...#####
        .#...##...
        .#...##...
        .#...##...
        .#..####..
        ########..
        .#######..
        .#...#.#..
        EOS
      }

      it "returns a grid with the beam path rendered" do
        ad.energize
        ad.debug!
        expect(ad.render_energized).to eq(energized.chomp)
      end
    end

    describe "#energize" do
      it "follows the beam path and returns the number of cells energized" do
        ad.debug!
        expect(ad.energize).to eq(46)
      end
    end

    context "validation" do
    end
  end
end