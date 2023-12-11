require './cosmic.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    EOS
  }

  describe Advent::Cosmic do
    let(:ad) { Advent::Cosmic.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "assigns galaxies and empty space" do
        expect(ad.grid[0,0]).to eq('.')
        expect(ad.grid[1,0]).to eq('.')
        expect(ad.grid[2,0]).to eq('.')
        expect(ad.grid[3,0]).to eq('#')
      end
    end

    describe "#expand_galaxy!" do
      it "expands the galaxy" do
        # ad.debug!
        ad.expand_galaxy!
        expect(ad.grid[4,0]).to eq('#')
        expect(ad.grid[0,2]).to eq('#')
        expect(ad.grid[8,5]).to eq('#')
      end

      it "marks the galaxy as expanded" do
        expect(ad.galaxy_expanded).to be_falsey
        ad.expand_galaxy!
        expect(ad.galaxy_expanded).to be_truthy
      end

      it "only expands the galaxy once" do
        ad.expand_galaxy!
        ad.expand_galaxy!
        expect(ad.grid[4,0]).to eq('#')
        expect(ad.grid[0,2]).to eq('#')
        expect(ad.grid[8,5]).to eq('#')
      end
    end

    describe "#shortest_path_sum" do
      it "returns the sum of the shortest path between all galaxies" do
        expect(ad.shortest_path_sum).to eq(374)
      end
    end

    context "validation" do
    end
  end
end
