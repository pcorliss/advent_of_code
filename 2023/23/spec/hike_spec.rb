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

      it "takes an argument to ignore slopes" do
        ad.debug!
        expect(ad.longest_hike(ignore_slopes: true)).to eq(154)
      end
    end

    describe "#build_graph" do
      it "Builds a graph" do
        ad.debug!
        g = ad.build_graph
        puts ad.render_graph_on_grid(highlight: false)

        expect(ad.distance('S', 'A')).to eq(15)
        expect(ad.distance('A', 'C')).to eq(22)
        expect(ad.distance('C', 'E')).to eq(38)
        expect(ad.distance('E', 'D')).to eq(10)
        expect(ad.distance('D', 'B')).to eq(24)
        expect(ad.distance('B', 'G')).to eq(30)
        expect(ad.distance('G', 'H')).to eq(10)
        expect(ad.distance('H', 'F')).to eq(5)

        puts ad.state_diagram
        # binding.pry
      end
    end

    context "validation" do
    end

#S#####################
#.......#########...###
#######.#########.#.###
###.....#.>B>.###.#.###
###v#####.#v#.###.#.###
###A>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>G#
#.#.#v#######v###.###v#
#...#C>.#...>D>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>E>.#.>H###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################F#
  end
end
