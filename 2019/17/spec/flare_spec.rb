require './flare.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Flare do
    let(:ad) { Advent::Flare.new(input) }

    describe "#new" do
      it "inits an intcode program" do
        expect(ad.program).to be_a(Advent::IntCode)
      end

      it "inits an empty grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid.cells).to be_empty
      end
    end

    describe "#fill_grid!" do
      it "fills a grid using the intcode program output" do
        ad.fill_grid!
        expect(ad.grid.cells).to_not be_empty
        expect(ad.grid.width).to eq(47)
        expect(ad.grid.cells).to include(
          [ 0, 0] => '.',
          [46, 0] => '.',
          [ 0,38] => '.',
          [46,38] => '.',
          [10, 4] => '#',
          [ 6,14] => '^',
        )
      end
    end

    context "requires grid" do
      before do
        ad.fill_grid!
      end
      describe "#intersections" do

        it "finds coordinates where cardinal directions and self are '#' symbols" do
          expect(ad.intersections).to include(
            [16, 6],
            [16, 8],
          )
        end
      end

      describe "#location" do
        it "returns the coordinates" do
          expect(ad.location).to eq([6,14])
        end
      end

      describe "#direction" do
        it "returns the direction" do
          expect(ad.direction).to eq(0)
        end
      end

      describe "#calculate_path" do
        it "returns right hand turn commands" do
          expect(ad.calculate_path[0]).to eq('R')
        end

        it "returns movement commands" do
          expect(ad.calculate_path[1]).to eq(12)
        end

        it "returns right hand turn commands" do
          expect(ad.calculate_path[2]).to eq('L')
        end

        it "continues on it's path even if there are other options" do
          expect(ad.calculate_path[3]).to eq(8)
        end

        it "visits every interscetion" do
          ad.calculate_path
          visited_intersections = ad.intersections & ad.visited.cells.keys
          expect(visited_intersections).to contain_exactly(*ad.intersections)
        end
      end

      describe "#repeated_sections" do
        it "finds repeated sections of length 2 in the path" do
          expect(ad.repeated_sections).to include(
            ['R', 12] => 7,
            ['L', 8] => 10,
          )
        end
        it "finds longer repeated sections" do
          expect(ad.repeated_sections).to include(
            ['R', 12, 'L', 6, 'L', 4] => 3,
          )
        end
      end
    end

    describe "#encoding" do
      it "encodes instructions as ascii chars" do
        expect(ad.encoding(["A"]).first).to eq(65)
      end

      it "terminates instructions with a newline (10)" do
        expect(ad.encoding(["A"])).to eq([65, 10])
      end

      it "separates instructions by commas (44)" do
        expect(ad.encoding(["A", "B"])).to eq([65, 44, 66, 10])
      end

      it "turns double digit numbers into two ascii encoded chars" do
        expect(ad.encoding(["R", 10])).to eq([82, 44, 49, 48, 10])
      end
    end

    context "validation" do
    end
  end
end
