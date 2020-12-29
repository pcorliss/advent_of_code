require './orbit.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
    EOS
  }


  describe Advent::Orbit do
    let(:ad) { Advent::Orbit.new(input) }

    describe "#new" do
      it "loads orbits" do
        expect(ad.orbits.count).to eq(8)
        expect(ad.orbits).to be_a(Hash)
        expect(ad.orbits['COM']).to be_a(Array)
      end
    end

    describe "#count_orbits" do
      it "counts orbits of center of mass to be 0" do
        expect(ad.count_orbits("COM")).to eq(0)
      end

      it "counts direct orbits" do
        expect(ad.count_orbits("B")).to eq(1)
      end

      it "counts indirect orbits" do
        expect(ad.count_orbits("C")).to eq(2)
      end

      it "handles deep desting" do
        expect(ad.count_orbits("L")).to eq(7)
      end

      it "validating transit pathing" do
        expect(ad.count_orbits("K")).to eq(6) # The thing you are orbiting
        expect(ad.count_orbits("I")).to eq(4) # The thing santa is orbiting
        expect(ad.count_orbits("D")).to eq(3) # Nearest Common Element between K & I
        # 6 - 3 + 4 - 3
        # count_orbits("K") - count_orbits("D") + count_orbits("I") - count_orbits("D")
      end
    end

    describe "#nearest_common_ancestor" do
      it "finds the common ancestor between two orbits" do
        expect(ad.nearest_common_ancestor("K", "I")).to eq("D")
      end
    end

    describe "#transfers_between_you_and_santa" do
      let(:input) {
        <<~EOS
          COM)B
          B)C
          C)D
          D)E
          E)F
          B)G
          G)H
          D)I
          E)J
          J)K
          K)L
          K)YOU
          I)SAN
        EOS
      }

      it "calculates transfers" do
        expect(ad.transfers_between_you_and_santa).to eq(4)
      end
    end

    context "validation" do
      it "calculates the total number of orbits" do
        sum = ad.reverse_orbits.keys.sum do |orb|
          ad.count_orbits(orb)
        end
        expect(sum).to eq(42)
      end
    end
  end
end
