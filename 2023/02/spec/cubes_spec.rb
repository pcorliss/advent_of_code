require './cubes.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    EOS
  }

  describe Advent::Cubes do
    let(:possible) { {red: 12, blue: 14, green: 13 } }
    let(:ad) { Advent::Cubes.new(input, possible) }

    describe "#new" do
    end

    describe "#possible?" do
      [true, true, false, false, true].each_with_index do |pos, idx|
        it "returns #{pos} if game #{idx + 1} is possible" do
          line = input.lines[idx]
          expect(ad.possible?(line)).to eq(pos)
        end
      end
    end

    context "validation" do
      it "returns the sum of possible games" do
        expect(ad.possible_game_sum).to eq(8)
      end
    end
  end
end
