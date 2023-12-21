require './steps.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    EOS
  }

  describe Advent::Steps do
    let(:ad) { Advent::Steps.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[0,0]).to eq('.')
        expect(ad.grid[2,2]).to eq('#')
      end

      it "replaces the start with a dot" do
        expect(ad.grid[5,5]).to eq('.')
      end

      it "inits a start" do
        expect(ad.start).to eq([5,5])
      end
    end

    describe "#steps" do
      {
        0 => 1,
        1 => 2,
        2 => 4,
        3 => 6,
        6 => 16
      }.each do |steps, expected_positions|
        it "returns the number of positions, #{expected_positions}, you can visit in #{steps} steps" do
          # ad.debug!
          positions = ad.steps(ad.start, steps)
          # puts "Pos: #{positions}"
          expect(positions.length).to eq(expected_positions)
        end
      end
    end

    context "validation" do
    end
  end
end
