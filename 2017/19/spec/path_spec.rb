require './path.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 
    EOS
  }

  describe Advent::Path do
    let(:ad) { Advent::Path.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[4,0]).to eq('|')
      end

      it "clears out empty chars" do
        expect(ad.grid[0,0]).to be_nil
      end
    end

    describe "#start" do
      it "returns the top-most pipe char position" do
        expect(ad.start).to eq([4,0])
      end
    end

    describe "#follow" do
      it "follows the line" do
        expect(ad.follow.join).to start_with('A')
      end

      it "returns the letters it would collect along the path" do
        expect(ad.follow.join).to eq("ABCDEF")
      end
    end

    context "validation" do
    end
  end
end
