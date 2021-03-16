require './bridge.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
    EOS
  }

  describe Advent::Bridge do
    let(:ad) { Advent::Bridge.new(input) }

    describe "#new" do
      it "inits a list of components" do
        expect(ad.comps.count).to eq(8)
        expect(ad.comp_lookup[3]).to contain_exactly([3,4],[2,3],[3,5])
      end
    end

    describe "#valid_parts" do
      it "returns a list of all components for the start of a bridge" do
        expect(ad.valid_parts([], 0)).to contain_exactly([0,2],[0,1])
      end

      it "returns all components for a passed bridge excluding used ones" do
        expect(ad.valid_parts([[0,2],[2,3]], 3)).to contain_exactly([3,4],[3,5])
      end

      it "doesn't return dupes" do
        expect(ad.valid_parts([[0,2]], 2)).to contain_exactly([2,2],[2,3])
      end
    end

    describe "#strength" do
      it "returns the strength of the bridge as the sum of its pins" do
        expect(ad.strength([[0,1],[10,1],[9,10]])).to eq(31)
      end
    end

    describe "#bridges" do
      it "returns a list of valid single part bridges" do
        expect(ad.bridges).to include(
          [[0,1]],
          [[0,2]],
        )
      end

      it "returns two-part bridges" do
        expect(ad.bridges).to include(
          [[0,1],[10,1]],
          [[0,2],[2,3]],
        )
      end

      it "returns long bridges" do
        expect(ad.bridges).to include(
          [[0,2],[2,2],[2,3],[3,5]]
        )
      end

      it "doesn't return dupes" do
        expect(ad.bridges.count).to eq(ad.bridges.uniq.count)
      end

      it "doesn't return an empty bridge" do
        expect(ad.bridges).to_not include([])
      end

      it "returns proper count" do
        expect(ad.bridges.count).to eq(11)
        # ad.debug!
        # ad.bridges.each do |b|
        #   puts b.inspect
        # end
      end
    end

    describe "#strongest_bridge" do
      it "returns the strongest bridge" do
        expect(ad.strongest_bridge).to eq([[0,1],[10,1],[9,10]])
        expect(ad.strength(ad.strongest_bridge)).to eq(31)
      end
    end

    describe "#longest_bridge" do
      it "returns the longest bridge" do
        expect(ad.longest_bridge).to eq([[0,2],[2,2],[2,3],[3,5]])
        expect(ad.strength(ad.longest_bridge)).to eq(19)
      end
    end

    context "validation" do
    end
  end
end
