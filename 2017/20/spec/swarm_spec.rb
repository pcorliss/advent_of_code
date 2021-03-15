require './swarm.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
    p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
    EOS
  }

  describe Advent::Swarm do
    let(:ad) { Advent::Swarm.new(input) }

    describe "#new" do
      it "loads a list of particles" do
        expect(ad.particles.count).to eq(2)
      end

      it "loads their position" do
        expect(ad.particles.first[0]).to eq([3,0,0])
      end

      it "loads their velocity" do
        expect(ad.particles.first[1]).to eq([2,0,0])
      end

      it "loads their acceleration" do
        expect(ad.particles.first[2]).to eq([-1,0,0])
      end
    end

    describe "#closest_long_term" do
      it "returns the index of the particle closest to origin ignoring position and velocity" do
        expect(ad.closest_long_term).to eq(0)
      end
    end

    describe "#collision" do
      let(:input) {
        <<~EOS
        p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
        p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
        p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
        p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
        EOS
      }

      it "marks particles as collided" do
        expect(ad.collision).to contain_exactly(0,1,2)
        expect(ad.collision).to_not include(3)
      end
    end

    context "validation" do
    end
  end
end
