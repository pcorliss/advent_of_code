require './towers.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
    EOS
  }

  describe Advent::Towers do
    let(:ad) { Advent::Towers.new(input) }

    describe "#new" do
      it "inits a collection of towers and their weights" do
        expect(ad.towers['pbga']).to eq(66)
        expect(ad.towers['xhth']).to eq(57)
      end

      it "inits a tree of towers and their descendants" do
        expect(ad.descendants['pbga']).to be_empty
        expect(ad.descendants['ugml']).to eq(%w(gyxo ebii jptl))
      end

      it "inits a reverse lookup of parent" do
        expect(ad.parent['tknk']).to be_nil
        expect(ad.parent['padx']).to eq('tknk')
      end
    end

    describe "#bottom" do
      it "returns the only node with no parent" do
        expect(ad.bottom).to eq('tknk')
      end
    end

    describe "#tower_weight" do
      it "returns the weight of a single element that has no descendants" do
        expect(ad.tower_weight('pbga')).to eq(66)
      end

      it "returns the sum'd weight of an element with descendants" do
        expect(ad.tower_weight('ugml')).to eq(251)
      end

      it "returns the weight of nested elements" do
        expect(ad.tower_weight('tknk')).to eq(778)
      end
    end

    describe "#reweight" do
      it "identifies the node that is off weight" do
        ad.debug!
        expect(ad.reweight.first).to eq('ugml')
      end

      it "identifies the correct weight it should be" do
        expect(ad.reweight.last).to eq(60)
      end
    end

    context "validation" do
    end
  end
end
