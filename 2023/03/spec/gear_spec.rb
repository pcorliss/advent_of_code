require './gear.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
    EOS
  }

  describe Advent::Gear do
    let(:ad) { Advent::Gear.new(input) }

    describe "#new" do
      it "loads the input and parses it into a grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[0,0]).to eq(4)
        expect(ad.grid[1,0]).to eq(6)
        expect(ad.grid[2,0]).to eq(7)
        expect(ad.grid[3,0]).to eq(nil)
        expect(ad.grid[4,0]).to eq(nil)
        expect(ad.grid[5,0]).to eq(1)
        expect(ad.grid[6,0]).to eq(1)
        expect(ad.grid[7,0]).to eq(4)
        expect(ad.grid[8,0]).to eq(nil)
        expect(ad.grid[9,0]).to eq(nil)
        expect(ad.grid[10,0]).to eq(nil)
        expect(ad.grid[11,0]).to eq(nil)
        expect(ad.grid[3,1]).to eq('*')
      end
    end

    describe "#part_nums" do
      it "returns a set of unique part numbers" do
        expect(ad.part_nums).to contain_exactly(467, 35, 633, 617, 592, 755, 664, 598)
        expect(ad.part_nums).to_not include(114, 58)
      end
    end

    context "validation" do
      it "returns the part number sum for part 1" do
        expect(ad.part_nums.sum).to eq(4361)
      end
    end
  end
end
