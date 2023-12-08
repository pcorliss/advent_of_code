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

  let(:input_2) {
    <<~EOS
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
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

    describe "#ghost_steps" do
      it "returns the number of steps to the exit" do
        ad = Advent::Wasteland.new(input_2)
        ad.debug!
        expect(ad.ghost_steps).to eq(6)
      end
    end

    describe "#lcm" do
      it "returns the least common multiple of an array of numbers" do
        expect(ad.lcm([19, 21, 42])).to eq(798)
      end
    end

    context "validation" do
    end
  end
end
