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
  end
end
