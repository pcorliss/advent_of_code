require './pipes.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      0 <-> 2
      1 <-> 1
      2 <-> 0, 3, 4
      3 <-> 2, 4
      4 <-> 2, 3, 6
      5 <-> 6
      6 <-> 4, 5
    EOS
  }

  describe Advent::Pipes do
    let(:ad) { Advent::Pipes.new(input) }

    describe "#new" do
      it "constructs a mapping of connections" do
        expect(ad.pipe).to be_a(Hash)
        expect(ad.pipe[0]).to contain_exactly(2)
      end
    end

    describe "#connected" do
      it "doesn't include unconnected programs" do
        expect(ad.connected(0)).to_not include(1)
      end

      it "returns itself" do
        expect(ad.connected(0)).to include(0)
      end

      it "returns direct connections" do
        expect(ad.connected(0)).to include(2)
      end

      it "returns distant connections" do
        # ad.debug!
        expect(ad.connected(0)).to include(3,4,5,6)
      end
    end

    context "validation" do
      it "returns the correct amount of connected programs" do
        expect(ad.connected(0).count).to eq(6)
      end
    end
  end
end
