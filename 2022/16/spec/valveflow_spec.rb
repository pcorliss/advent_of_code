require './valveflow.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
    EOS
  }

  describe Advent::Valveflow do
    let(:ad) { Advent::Valveflow.new(input) }

    describe "#new" do
      it "loads a map of valves" do
        expect(ad.valves[:BB]).to eq(13)
        expect(ad.valves[:CC]).to eq(2)
      end

      it "does not load valves with flow rates of zero" do
        expect(ad.valves[:AA]).to be_nil
      end

      it "maps tunnels" do
        expect(ad.tunnels[:AA]).to eq([:DD, :II, :BB])
        expect(ad.tunnels[:HH]).to eq([:GG])
      end

      {
        [:AA,:DD] => 1,
        [:AA,:EE] => 2,
        [:AA,:FF] => 3,
        [:AA,:GG] => 4,
        [:AA,:HH] => 5,
      }.each do |start_end, distance|
        it "precomputes costs from #{start_end} as #{distance}" do
          s, e = start_end
          expect(ad.travel[s][e]).to eq(distance)
        end
      end
    end

    describe "#most_pressure" do
      it "returns the candidate with the most pressure" do
        ad.debug!
        expect(ad.most_pressure.gas).to eq(1651)
      end
    end



    context "validation" do
    end
  end
end
