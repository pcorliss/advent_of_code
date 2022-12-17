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
        # [:AA,:FF] => 3,
        # [:AA,:GG] => 4,
        [:AA,:HH] => 5,
        [:HH,:EE] => 3,
      }.each do |start_end, distance|
        it "precomputes costs from #{start_end} as #{distance}" do
          s, e = start_end
          expect(ad.travel[s][e]).to eq(distance)
        end
      end
    end

    describe "#most_pressure" do
      it "returns the candidate with the most pressure" do
        # ad.debug!
        expect(ad.most_pressure.gas).to eq(1651)
      end
    end



    context "validation" do
      let(:linear) {
        <<~EOS
      Valve AA has flow rate=0; tunnels lead to valves BA
      Valve BA has flow rate=2; tunnels lead to valves AA, CA
      Valve CA has flow rate=4; tunnels lead to valves BA, DA
      Valve DA has flow rate=6; tunnels lead to valves CA, EA
      Valve EA has flow rate=8; tunnels lead to valves DA, FA
      Valve FA has flow rate=10; tunnels lead to valves EA, GA
      Valve GA has flow rate=12; tunnels lead to valves FA, HA
      Valve HA has flow rate=14; tunnels lead to valves GA, IA
      Valve IA has flow rate=16; tunnels lead to valves HA, JA
      Valve JA has flow rate=18; tunnels lead to valves IA, KA
      Valve KA has flow rate=20; tunnels lead to valves JA, LA
      Valve LA has flow rate=22; tunnels lead to valves KA, MA
      Valve MA has flow rate=24; tunnels lead to valves LA, NA
      Valve NA has flow rate=26; tunnels lead to valves MA, OA
      Valve OA has flow rate=28; tunnels lead to valves NA, PA
      Valve PA has flow rate=30; tunnels lead to valves OA
        EOS
      }

      # Part 1: 2640
      # Part 2: 2670
      # 1240 |AA|DA|EA|FA|GA|HA|IA|JA|CA
      # 1430 |AA|KA|LA|MA|NA|OA|PA

      it "handles a linear test case" do
        ad = Advent::Valveflow.new(linear)
        # puts ad.travel.inspect
        # ad.debug!
        expect(ad.most_pressure.gas).to eq(2640)
      end
    end
  end
end
