require './rocks.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    EOS
  }

  describe Advent::Rocks do
    let(:ad) { Advent::Rocks.new(input) }

    describe "#new" do
      it "inits a grid of rocks" do
        expect(ad.grid[0,0]).to eq('O')
        expect(ad.grid[1,0]).to eq('.')
        expect(ad.grid[0,1]).to eq('O')
      end
    end

    describe "#tilt!" do
      let(:expected_tilt) {
        <<~EOS
        OOOO.#.O..
        OO..#....#
        OO..O##..O
        O..#.OO...
        ........#.
        ..#....#.#
        ..O..#.O.O
        ..O.......
        #....###..
        #....#....
        EOS
      }
      it "tilts the rocks northwards" do
        ad.tilt!
        expect(ad.grid.render).to eq(expected_tilt.chomp)
      end
    end

    describe "#spin!" do
      let(:cycle) {[(
        <<~EOS
        .....#....
        ....#...O#
        ...OO##...
        .OO#......
        .....OOO#.
        .O#...O#.#
        ....O#....
        ......OOOO
        #...O###..
        #..OO#....
        EOS
        ),(
        <<~EOS
        .....#....
        ....#...O#
        .....##...
        ..O#......
        .....OOO#.
        .O#...O#.#
        ....O#...O
        .......OOO
        #..OO###..
        #.OOO#...O
        EOS
        ),(
        <<~EOS
        .....#....
        ....#...O#
        .....##...
        ..O#......
        .....OOO#.
        .O#...O#.#
        ....O#...O
        .......OOO
        #...O###.O
        #.OOO#...O
        EOS
        )
      ]}

      3.times do |i|
        it "spins the rocks clockwise #{i+1} times" do
          (i+1).times { ad.spin! }
          expect(ad.grid.render).to eq(cycle[i].chomp)
        end
      end
    end

    describe "#total_load" do
      it "returns the total load" do
        ad.tilt!
        expect(ad.total_load).to eq(136)
      end
    end

    describe "#multi_spin_load" do
      it "uses cycle detection to determine the load after many spins" do
        # ad.debug!
        expect(ad.multi_spin_load(1_000_000_000)).to eq(64)
      end
    end
  end
end
