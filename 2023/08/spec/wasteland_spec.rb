require './wasteland.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
    EOS
  }

  let(:looping_input) {
    <<~EOS
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ
    EOS
  }

  describe Advent::Wasteland do
    let(:ad) { Advent::Wasteland.new(input) }

    describe "#new" do
      it "initializes directions" do
        expect(ad.directions).to eq([:R, :L])
      end

      it "initializes a mapping" do
        expect(ad.mapping).to eq({
          :AAA => [:BBB, :CCC],
          :BBB => [:DDD, :EEE],
          :CCC => [:ZZZ, :GGG],
          :DDD => [:DDD, :DDD],
          :EEE => [:EEE, :EEE],
          :GGG => [:GGG, :GGG],
          :ZZZ => [:ZZZ, :ZZZ],
        })
      end
    end

    describe "#steps" do
      it "returns the number of steps to the exit" do
        expect(ad.steps).to eq(2)
      end

      it "returns the number of steps for a looping example" do
        ad = Advent::Wasteland.new(looping_input)
        expect(ad.steps).to eq(6)
      end
    end

    context "validation" do
    end
  end
end
