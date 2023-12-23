require './hike.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
    EOS
  }

  describe Advent::Hike do
    let(:ad) { Advent::Hike.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid[0,0]).to eq('#')
        expect(ad.grid[1,1]).to eq('.')
      end

      it "inits a start" do
        expect(ad.start).to eq([1,0])
      end

      it "inits a finish" do
        expect(ad.finish).to eq([21,22])
      end
    end

    describe "#longest_hike" do
      it "returns the longest hike" do
        # ad.debug!
        expect(ad.longest_hike).to eq(94)
      end
    end

    context "validation" do
    end
  end
end
