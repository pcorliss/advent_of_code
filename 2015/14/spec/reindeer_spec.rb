require './reindeer.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    EOS
  }

  describe Advent::Reindeer do
    let(:ad) { Advent::Reindeer.new(input) }

    describe "#new" do
      it "inits a reindeer map" do
        expect(ad.reindeer['Comet']).to eq({
          speed: 14,
          duration: 10,
          rest: 127,
        })
      end
    end

    describe "#distance" do
      it "returns the distance from the start given a duration ignorning rests" do
        expect(ad.distance('Comet', 1)).to eq(14)
        expect(ad.distance('Dancer', 1)).to eq(16)
        expect(ad.distance('Comet', 10)).to eq(140)
        expect(ad.distance('Dancer', 10)).to eq(160)
      end

      it "returns the distance factoring in resting" do
        expect(ad.distance('Comet', 11)).to eq(140)
        expect(ad.distance('Dancer', 11)).to eq(176)
      end

      it "handles resumption after rest" do
        expect(ad.distance('Comet', 138)).to eq(154)
        expect(ad.distance('Dancer', 138)).to eq(176)
        expect(ad.distance('Comet', 140)).to eq(182)
        expect(ad.distance('Dancer', 140)).to eq(176)
      end
    end

    describe "#winner" do
      it "returns the winning reindeer at a particular time" do
        expect(ad.winner(1)).to eq('Dancer')
      end

      it "returns the winning reindeer at a particular time" do
        expect(ad.winner(140)).to eq('Comet')
      end
    end

    describe "#points" do
      it "returns the point total after a given number of seconds" do
        expect(ad.points(1)).to eq({
          'Dancer' => 1,
        })
      end

      it "returns the point total after multiple seconds" do
        expect(ad.points(2)).to eq({
          'Dancer' => 2,
        })
      end

      it "handles ties" do
        inp = <<~EOS
          Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
          Dancer can fly 14 km/s for 11 seconds, but then must rest for 162 seconds.
        EOS
        ad = Advent::Reindeer.new(inp)

        expect(ad.points(3)).to eq({
          'Dancer' => 3,
          'Comet' => 3,
        })
      end
    end

    context "validation" do
      it "at the 1000th seconds" do
        expect(ad.points(1000)).to eq({
          'Dancer' => 689,
          'Comet' => 312,
        })
        expect(ad.distance('Comet', 1000)).to eq(1120)
        expect(ad.distance('Dancer', 1000)).to eq(1056)
        expect(ad.winner(1000)).to eq('Comet')
      end
    end
  end
end
