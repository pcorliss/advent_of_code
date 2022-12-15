require './falling.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    EOS
  }

  describe Advent::Falling do
    let(:ad) { Advent::Falling.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to_not be_nil
      end

      it "draws on the grid" do
        ad.debug!
        expect(ad.grid[498,4]).to eq('#')
        expect(ad.grid[498,5]).to eq('#')
        expect(ad.grid[498,6]).to eq('#')
        expect(ad.grid[497,6]).to eq('#')
        expect(ad.grid[496,6]).to eq('#')

        expect(ad.grid[503,4]).to eq('#')
        expect(ad.grid[502,4]).to eq('#')
        expect(ad.grid[502,5]).to eq('#')
        expect(ad.grid[502,9]).to eq('#')
        expect(ad.grid[494,9]).to eq('#')
      end

      it "sets the max y" do
        expect(ad.max_y).to eq(9)
      end
    end

    describe "#drop_sand" do
      it "drops sand straight down" do
        ad.drop_sand
        expect(ad.grid[500,8]).to eq('o')
      end

      it "if blocked sand falls to the left" do
        ad.grid[500,8] = 'o'
        ad.drop_sand
        expect(ad.grid[499,8]).to eq('o')
      end

      it "if blocked sand falls to the right" do
        ad.grid[500,8] = 'o'
        ad.grid[499,8] = 'o'
        ad.drop_sand
        expect(ad.grid[501,8]).to eq('o')
      end
      let(:expected) {
      <<~EOS
            o   
           ooo  
          #ooo##
         o#ooo# 
        ###ooo# 
          oooo# 
       o ooooo# 
      ######### 
      EOS
      }
      it "forms a pattern after 24 units" do
        24.times { ad.drop_sand }
        expect(ad.grid.render.strip).to eq(expected.strip)
      end

      it "returns nil if the sand falls into the void" do
        24.times { ad.drop_sand }
        expect(ad.drop_sand).to eq(nil)
      end
    end

    describe "#fill_sand!" do
      it "returns the number of sand grains before they start falling" do
        expect(ad.fill_sand!).to eq(24)
      end
    end

    context "validation" do
    end
  end
end
