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

    context "validation" do
    end
  end
end
