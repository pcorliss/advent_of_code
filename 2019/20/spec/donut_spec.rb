require './donut.rb'
require 'rspec'
require 'pry'

describe Advent do

  A_SAMPLE = <<~EOS
         A           
         A           
  #######.#########  
  #######.........#  
  #######.#######.#  
  #######.#######.#  
  #######.#######.#  
  #####  B    ###.#  
BC...##  C    ###.#  
  ##.##       ###.#  
  ##...DE  F  ###.#  
  #####    G  ###.#  
  #########.#####.#  
DE..#######...###.#  
  #.#########.###.#  
FG..#########.....#  
  ###########.#####  
             Z       
             Z       
    EOS
  B_SAMPLE = <<~EOS
                   A               
                   A               
  #################.#############  
  #.#...#...................#.#.#  
  #.#.#.###.###.###.#########.#.#  
  #.#.#.......#...#.....#.#.#...#  
  #.#########.###.#####.#.#.###.#  
  #.............#.#.....#.......#  
  ###.###########.###.#####.#.#.#  
  #.....#        A   C    #.#.#.#  
  #######        S   P    #####.#  
  #.#...#                 #......VT
  #.#.#.#                 #.#####  
  #...#.#               YN....#.#  
  #.###.#                 #####.#  
DI....#.#                 #.....#  
  #####.#                 #.###.#  
ZZ......#               QG....#..AS
  ###.###                 #######  
JO..#.#.#                 #.....#  
  #.#.#.#                 ###.#.#  
  #...#..DI             BU....#..LF
  #####.#                 #.#####  
YN......#               VT..#....QG
  #.###.#                 #.###.#  
  #.#...#                 #.....#  
  ###.###    J L     J    #.#.###  
  #.....#    O F     P    #.#...#  
  #.###.#####.#.#####.#####.###.#  
  #...#.#.#...#.....#.....#.#...#  
  #.#####.###.###.#.#.#########.#  
  #...#.#.....#...#.#.#.#.....#.#  
  #.###.#####.###.###.#.#.#######  
  #.#.........#...#.............#  
  #########.###.###.#############  
           B   J   C               
           U   P   P               
EOS

  let(:input) { A_SAMPLE }

  describe Advent::Donut do
    let(:ad) { Advent::Donut.new(input) }

    describe "#new" do
      it "instantiates a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "maps points" do
        expect(ad.points).to include(
          'AA' => [[9,2]],
          'BC' => contain_exactly([2,8],[9,6]),
          [2,8] => [9,6],
          [9,6] => [2,8],
        )
      end

    end

    describe "#start_pos" do
      it "finds the start position" do
        expect(ad.start_pos).to eq([9,2])
      end
    end

    describe "#end_pos" do
      it "finds the end position" do
        expect(ad.end_pos).to eq([13,16])
      end
    end

    describe "#steps" do

    end

    context "validation" do
      {
        A_SAMPLE => 23,
        B_SAMPLE => 58,
      }.each do |inp, steps|
        it "produces the correct number of steps (#{steps})" do
          ad = Advent::Donut.new(inp)
          # ad.debug!
          expect(ad.steps).to eq(steps)
        end
      end
    end
  end
end
