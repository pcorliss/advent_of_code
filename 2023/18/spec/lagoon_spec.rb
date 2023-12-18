require './lagoon.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    EOS
  }

  describe Advent::Lagoon do
    let(:ad) { Advent::Lagoon.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "inits a list of commands" do
        expect(ad.commands.count).to eq(14)
        expect(ad.commands.first).to eq([:R, 6, '70c710'])
        expect(ad.commands.last).to eq([:U, 2, '7a21e3'])
      end

      it "inits hex commands" do
        expect(ad.hex_commands.count).to eq(14)
        expect(ad.hex_commands.first).to eq([:R, 461937])
        expect(ad.hex_commands[2]).to eq([:R, 356671])
      end
    end

    describe "#swap_commands" do
      it "swaps the commands with the hex commands" do
        ad.swap_commands
        expect(ad.commands.first).to eq([:R, 461937])
      end

      # it "test" do
      #   ad.swap_commands
      #   ad.commands.each_with_index do |(dir, len, color), idx|
      #     ad.commands[idx] = [dir, len / 1000, color]
      #   end
      # end
    end

    describe "#cut_edge" do
      let(:expected) {
        <<-EOS
#######
#     #
###   #
  #   #
  #   #
### ###
#   #  
##  ###
 #    #
 ######
EOS
      }
      it "cuts the edge" do
        ad.cut_edge
        expect(ad.grid.render).to eq(expected.chomp)
      end
    end

    describe "#fill_lagoon" do
      let(:expected) {
        <<-EOS
#######
#######
#######
  #####
  #####
#######
#####  
#######
 ######
 ######
EOS
      }
      it "fills the lagoon between the trench lines" do
        ad.cut_edge
        # ad.debug!
        ad.fill_lagoon
        expect(ad.grid.render).to eq(expected.chomp)
      end
    end

    describe "#lagoon_size" do
      it "returns the size of the lagoon" do
        ad.cut_edge
        ad.fill_lagoon
        expect(ad.lagoon_size_slow).to eq(62)
        expect(ad.lagoon_size).to eq(62)
      end

      it "returns the size of the lagoon for part 2" do
        ad.swap_commands
        expect(ad.lagoon_size).to eq(952408144115)
      end
    end

    context "validation" do
    end
  end
end
