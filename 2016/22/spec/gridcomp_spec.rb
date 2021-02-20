require './gridcomp.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    root@ebhq-gridcenter# df -h
    Filesystem              Size  Used  Avail  Use%
    /dev/grid/node-x0-y0     89T   65T    24T   73%
    /dev/grid/node-x0-y1     92T   65T    27T   70%
    /dev/grid/node-x1-y0     86T   68T    18T   79%
    /dev/grid/node-x1-y1     86T    1T    85T   79%
    EOS
  }

  describe Advent::Gridcomp do
    let(:ad) { Advent::Gridcomp.new(input) }

    describe "#new" do
      it "inits a list of filesystem nodes" do
        expect(ad.nodes.count).to eq(4)
        expect(ad.nodes.first).to eq([[0,0], 89, 65])
      end
    end

    describe "#viable_pair?" do
      let(:empty_node)        { [[0,0], 100,  0] }
      let(:almost_full_node)  { [[1,0], 100, 99] }
      let(:partial_node)      { [[2,0], 100, 10] }

      it "returns false if A is empty" do
        expect(ad.viable_pair?(empty_node, partial_node)).to be_falsey
      end

      it "returns false if A and B are the same node" do
        expect(ad.viable_pair?(partial_node, partial_node)).to be_falsey
      end

      it "returns false if A wouldn't fit on B" do
        expect(ad.viable_pair?(partial_node, almost_full_node)).to be_falsey
      end

      it "returns true if all conditions are met" do
        expect(ad.viable_pair?(partial_node, empty_node)).to be_truthy
      end
    end

    describe "#count_viable_pairs" do
      it "returns the number of viable pairs" do
        expect(ad.count_viable_pairs).to eq(6)
      end
    end

    context "part 2" do
      let(:input) {
        <<~EOS
        Filesystem            Size  Used  Avail  Use%
        /dev/grid/node-x0-y0   10T    8T     2T   80%
        /dev/grid/node-x0-y1   11T    6T     5T   54%
        /dev/grid/node-x0-y2   32T   28T     4T   87%
        /dev/grid/node-x1-y0    9T    7T     2T   77%
        /dev/grid/node-x1-y1    8T    0T     8T    0%
        /dev/grid/node-x1-y2   11T    7T     4T   63%
        /dev/grid/node-x2-y0   10T    6T     4T   60%
        /dev/grid/node-x2-y1    9T    8T     1T   88%
        /dev/grid/node-x2-y2    9T    6T     3T   66%
        EOS
      }

      describe "#adjacent?" do
        it "returns true for adjacent pairs" do
          a = ad.nodes.find {|n| n.first == [0,0]}
          b = ad.nodes.find {|n| n.first == [1,0]}
          c = ad.nodes.find {|n| n.first == [0,1]}
          expect(ad.adjacent?(a,b)).to be_truthy
          expect(ad.adjacent?(a,c)).to be_truthy
        end

        it "returns false for non-adjacent pairs" do
          a = ad.nodes.find {|n| n.first == [1,0]}
          b = ad.nodes.find {|n| n.first == [0,1]}
          expect(ad.adjacent?(a,b)).to be_falsey
        end
      end

      describe "#fewest_steps" do
        it "returns the fewest number of steps to move data to target" do
          ad.debug!
          expect(ad.fewest_steps).to eq(7)
        end
      end
    end
  end
end
