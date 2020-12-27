require '../nav.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
F10
N3
F7
R90
F11
    EOS
  }

  describe Advent::Nav do
    let(:ad) { Advent::Nav.new(input) }

    describe "#new" do
    end

    describe "#move!" do
      it "moves forward" do
        expect(ad.pos).to eq([0,0])
        expect(ad.direction).to eq(90)
        ad.move!("F10")
        expect(ad.pos).to eq([10,0])
        expect(ad.direction).to eq(90)
      end

      it "moves cardinal" do
        expect(ad.pos).to eq([0,0])
        expect(ad.direction).to eq(90)
        ad.move!("N10")
        expect(ad.pos).to eq([0,10])
        expect(ad.direction).to eq(90)
      end

      it "turns" do
        expect(ad.pos).to eq([0,0])
        expect(ad.direction).to eq(90)
        ad.move!("R90")
        ad.move!("F10")
        expect(ad.pos).to eq([0,-10])
        expect(ad.direction).to eq(180)
      end
    end

    describe "#manhattan" do
      it "returns the manhattan distance" do
        ad.exec!
        expect(ad.manhattan).to eq(25)
      end
    end

    context "validation" do
    end
  end

  describe Advent::Nav2 do
    let(:ad) { Advent::Nav2.new(input) }

    describe "#new" do
    end

    describe "#move!" do
      it "moves forward" do
        expect(ad.pos).to eq([0,0])
        ad.move!("F10")
        expect(ad.pos).to eq([100,10])
      end

      it "moves waypoint cardinal" do
        expect(ad.pos).to eq([0,0])
        expect(ad.way).to eq([10,1])
        ad.move!("N10")
        expect(ad.pos).to eq([0,0])
        expect(ad.way).to eq([10,11])
      end

      it "turns" do
        ad.move!("N3")
        expect(ad.way).to eq([10,4])
        ad.move!("R90")
        expect(ad.way).to eq([4,-10])
        ad.move!("L90")
        expect(ad.way).to eq([10,4])
      end
    end

    describe "#manhattan" do
      it "returns the manhattan distance" do
        ad.exec!
        expect(ad.manhattan).to eq(286)
      end
    end

    context "validation" do
    end
  end
end
