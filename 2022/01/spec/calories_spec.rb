require './calories.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    1000
    2000
    3000
    
    4000
    
    5000
    6000
    
    7000
    8000
    9000
    
    10000
    EOS
  }

  describe Advent::Calories do
    let(:ad) { Advent::Calories.new(input) }

    describe "#new" do
      it "The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories." do
        expect(ad.elves[0]).to eq([1000,2000,3000])
      end

      it "The second Elf is carrying one food item with 4000 Calories." do
        expect(ad.elves[1]).to eq([4000])
      end
      it "The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories." do
        expect(ad.elves[2]).to eq([5000,6000])
      end
      it "The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories." do
        expect(ad.elves[3]).to eq([7000,8000,9000])
      end
      it "The fifth Elf is carrying one food item with 10000 Calories." do
        expect(ad.elves[4]).to eq([10000])
      end
    end

    describe "#most_calories" do
      it "returns the sum of calories carried by the elf with the most" do
        expect(ad.most_calories).to eq(24000)
      end
    end

    context "validation" do
    end
  end
end
