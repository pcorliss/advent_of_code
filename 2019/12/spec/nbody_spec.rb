require './nbody.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
    EOS
  }

  describe Advent::Nbody do
    let(:ad) { Advent::Nbody.new(input) }
    let(:moon) { ad.moons.first }

    describe "#new" do
      it "inits a moons collection" do
        expect(ad.moons.count).to eq(4)
        expect(moon).to be_a(Advent::Moon)
      end
    end

    describe "#step!" do
      it "modifies velocity" do
        expect(moon.velocity).to eq([0,0,0])
        ad.step!
        expect(moon.velocity).to eq([3,-1,-1])
      end

      it "modifies position" do
        expect(moon.pos).to eq([-1,0,2])
        ad.step!
        expect(moon.pos).to eq([2,-1,1])
      end
    end

    describe "#previous_state?" do
      it "returns false if we haven't seen this state before" do
        expect(ad.previous_state?).to be_falsey
      end

      it "returns true if we have seen this state before" do
        2771.times { ad.step! }
        expect(ad.previous_state?).to be_falsey
        ad.step!
        expect(ad.previous_state?).to be_truthy
      end
    end

    context "validation" do
      context "after ten steps" do
        [
          [2, 1,-3],
          [1,-8, 0],
          [3,-6, 1],
          [2, 0, 4],
        ].each_with_index do |expected, i|
          it "updates the position of the #{i} element" do
            10.times { ad.step! }
            expect(ad.moons[i].pos).to eq(expected)
          end
        end

        [
          [-3,-2, 1],
          [-1, 1, 3],
          [ 3, 2,-3],
          [ 1,-1,-1],
        ].each_with_index do |expected, i|
          it "updates the velocity of the #{i} element" do
            10.times { ad.step! }
            expect(ad.moons[i].velocity).to eq(expected)
          end
        end
      end

      context "longer cycles" do
        let(:input) { <<~EOS
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
        EOS
        }

        xit "takes a really long time to find a previous state" do
          i = 0
          until ad.previous_state? do
            ad.step!
            i += 1
            puts "#{i}" if i % 100_000 == 0
            break if i > 4_686_774_924
          end
          expect(i).to eq(4686774924)
        end
      end
    end
  end

  describe Advent::Moon do
    let(:moon) { Advent::Moon.new(input.lines.first.chomp) }

    describe "#new" do
      it "inits a moon position and velocity" do
        expect(moon.pos).to eq([-1,0,2])
        expect(moon.velocity).to eq([0,0,0])
      end
    end

    describe "#kinetic_energy" do
      it "returns the kinetic energy (abs val) sum of position" do
        expect(moon.kinetic_energy).to eq(3)
      end
    end

    describe "#potential_energy" do
      it "returns the potential energy (abs val) sum of velocity" do
        moon.velocity = [1,2,3]
        expect(moon.potential_energy).to eq(6)
      end
    end

    describe "#total_energy" do
      it "returns the total energy (potential * kinetic(" do
        moon.velocity = [1,2,3]
        expect(moon.energy).to eq(18)
      end
    end
  end
end
