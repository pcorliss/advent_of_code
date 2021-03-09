require './defrag.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    flqrgnkx
    EOS
  }

  describe Advent::Defrag do
    let(:ad) { Advent::Defrag.new(input) }

    describe "#new" do
      it "inits the seed" do
        expect(ad.seed).to eq("flqrgnkx")
      end

      it "inits an empty grid" do
        expect(ad.grid).to be_a(Grid)
      end
    end

    describe "#knot_hash" do
      it "returns the knot hash of a string" do
        expect(ad.knot_hash("flqrgnkx-0")).to eq("d4f76bdcbf838f8416ccfa8bc6d1f9e6")
      end
    end

    describe "#knot_bits" do
      it "returns the bits of a string" do
        expect(ad.knot_bits("flqrgnkx-0")).to start_with(1,1,0,1,0,1,0,0)
      end

      it "pads zeros" do
        expect(ad.knot_bits("flqrgnkx-1")).to start_with(0,1,0,1,0,1,0,1)
      end
    end

    describe "#fill_grid!" do
      it "populates the grid" do
        ad.fill_grid!
        rendering = ad.grid.render.lines.first(8).map {|l| l[0...8] }
        expect(rendering).to eq([
          '##.#.#..',
          '.#.#.#.#',
          '....#.#.',
          '#.#.##.#',
          '.##.#...',
          '##..#..#',
          '.#...#..',
          '##.#.##.',
        ])
      end
    end

    describe "#used_squares" do
      it "returns the used squares in a filled grid" do
        ad.fill_grid!
        expect(ad.used_squares).to eq(8108)
      end
    end

    context "validation" do
    end
  end
end
