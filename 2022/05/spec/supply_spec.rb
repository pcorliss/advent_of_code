require './supply.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
    EOS
  }

  describe Advent::Supply do
    let(:ad) { Advent::Supply.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions.count).to eq(4)
        expect(ad.instructions[0]).to eq({
          move: 1,
          from: 2,
          to: 1,
        })
      end

      it "loads stacks and creates" do
        expect(ad.stacks.count).to eq(3)
        expect(ad.stacks[0]).to eq(['Z', 'N'])
      end
    end

    context "validation" do
    end

    describe "#move!" do
      it "moves a crate from one stack to another" do
        ad.move!(ad.instructions[0])
        expect(ad.stacks[0]).to eq(['Z', 'N', 'D'])
        expect(ad.stacks[1]).to eq(['M', 'C'])
      end

      it "moves multiple crates one at a time" do
        ad.move!(ad.instructions[0])
        ad.move!(ad.instructions[1])
        expect(ad.stacks[0]).to be_empty
        expect(ad.stacks[2]).to eq(['P', 'D', 'N', 'Z'])
      end
    end

    describe "#move_multi!" do
      it "moves a crate from one stack to another" do
        ad.move_multi!(ad.instructions[0])
        expect(ad.stacks[0]).to eq(['Z', 'N', 'D'])
        expect(ad.stacks[1]).to eq(['M', 'C'])
      end

      it "moves multiple crates one at a time" do
        ad.move_multi!(ad.instructions[0])
        ad.move_multi!(ad.instructions[1])
        expect(ad.stacks[0]).to be_empty
        expect(ad.stacks[2]).to eq(['P', 'Z', 'N', 'D'])
      end
    end

    describe "#run!" do
      it "runs all instructions" do
        ad.run!
        expect(ad.stacks[0]).to eq(['C'])
        expect(ad.stacks[1]).to eq(['M'])
        expect(ad.stacks[2]).to eq(['P', 'D', 'N', 'Z'])
      end
    end

    describe "#run_multi!" do
      it "runs all instructions" do
        ad.run_multi!
        expect(ad.stacks[0]).to eq(['M'])
        expect(ad.stacks[1]).to eq(['C'])
        expect(ad.stacks[2]).to eq(['P', 'Z', 'N', 'D'])
      end
    end

    describe "#top_of_stacks" do
      it "returns the top item of each stack" do
        ad.run!
        expect(ad.top_of_stacks).to eq('CMZ')
      end
    end
  end
end
