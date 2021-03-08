require './firewall.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
0: 3
1: 2
4: 4
6: 4
    EOS
  }

  describe Advent::Firewall do
    let(:ad) { Advent::Firewall.new(input) }

    describe "#new" do
      it "inits layers" do
        expect(ad.layers.count).to eq(4)
        expect(ad.layers[0]).to eq(3)
      end
    end

    describe "#cur_depth" do
      {
        [6,0] => 0,
        [6,1] => 1,
        [6,2] => 2,
        [6,3] => 3,
        [6,4] => 2,
        [6,5] => 1,
        [6,6] => 0,
        [6,7] => 1,
        [0,0] => 0,
        [0,1] => 1,
        [0,2] => 2,
        [0,3] => 1,
        [0,4] => 0,
        [0,5] => 1,
        [0,6] => 2,
      }.each do |layer_and_t, expected_depth|
        it "returns the current depth #{expected_depth} of a layer #{layer_and_t.first} given a time-index #{layer_and_t.last}" do
          expect(ad.cur_depth(*layer_and_t)).to eq(expected_depth)
        end
      end

      it "returns -1 for layers with no depth" do
        expect(ad.cur_depth(2, 0)).to eq(-1)
      end
    end

    describe "#caught?" do
      {
        0 => true,
        6 => true,
        1 => false,
        2 => false,
        3 => false,
        4 => false,
        5 => false,
      }.each do |t, caught|
        it "returns #{caught} at time index #{t}" do
          expect(ad.caught?(t)).to eq(caught)
        end
      end
    end

    describe "#severity" do
      it "returns the total severity of the trip" do
        expect(ad.severity).to eq(24)
      end
    end

    context "validation" do
    end
  end
end
