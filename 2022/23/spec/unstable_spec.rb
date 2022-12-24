require './unstable.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    ....#..
    ..###.#
    #...#.#
    .#...##
    #.###..
    ##.#.##
    .#..#..
    EOS
  }

  describe Advent::Unstable do
    let(:ad) { Advent::Unstable.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid[0,0]).to be_nil
        expect(ad.grid[4,0]).to eq('#')
        expect(ad.grid[3,1]).to eq('#')
        expect(ad.grid[6,5]).to eq('#')
        expect(ad.grid[6,6]).to be_nil
      end

      it "inits a dir_idx" do
        expect(ad.dir_idx).to eq(0)
      end
    end


    describe "#step!" do
      # If no other Elves are in one of those eight positions, the Elf does not do anything during this round.
      it "if no spaces are occupied the elf does nothing." do
        ad = Advent::Unstable.new("#")
        ad.step!
        expect(ad.grid[0,0]).to eq('#')
      end

      # If there is no Elf in the N, NE, or NW adjacent positions, the Elf proposes moving north one step.
      it "No elf is N, NE, NW move N" do
        ad.step!
        expect(ad.grid[4,-1]).to eq('#')
      end

      # If there is no Elf in the S, SE, or SW adjacent positions, the Elf proposes moving south one step.
      it "No elf is S, SE, SW move S" do
        ad.step!
        expect(ad.grid[1,7]).to eq('#')
      end

      # If there is no Elf in the W, NW, or SW adjacent positions, the Elf proposes moving west one step.
      it "No elf is W, NW, SW move W" do
        expect(ad.grid[0,4]).to eq('#')
        ad.step!
        expect(ad.grid[-1,4]).to eq('#')
      end

      # If there is no Elf in the E, NE, or SE adjacent positions, the Elf proposes moving east one step.
      it "No elf is E, NE, SE move E" do
        expect(ad.grid[6,2]).to eq('#')
        ad.step!
        expect(ad.grid[7,2]).to eq('#')
      end

      # each Elf moves to their proposed destination tile if they were the only Elf to propose moving to that position.
      it "two elves can't move to the same position" do
        expect(ad.grid[6,3]).to eq('#')
        expect(ad.grid[6,5]).to eq('#')
        ad.step!
        expect(ad.grid[6,3]).to eq('#')
        expect(ad.grid[6,5]).to eq('#')
      end

      # Finally, at the end of the round, the first direction the Elves considered is moved to the end of the list of directions.
      xit "directions change in order" do
        ad.step!
        # expect(ad.grid[4,-1]).to eq('#')
        ad.step!
        # expect(ad.grid[4,0]).to eq('#')
      end
    end

    describe '#empty_ground' do
      it "returns the empty spaces" do
        10.times {ad.step!}
        expect(ad.empty_ground).to eq(110)
      end
    end

    context "validation" do
    end
  end
end
