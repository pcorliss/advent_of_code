require './recursive_donut.rb'
require 'rspec'
require 'pry'

describe Advent do

  C_SAMPLE = <<~EOS
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
  D_SAMPLE = <<~EOS
             Z L X W       C                 
             Z P Q B       K                 
  ###########.#.#.#.#######.###############  
  #...#.......#.#.......#.#.......#.#.#...#  
  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###  
  #.#...#.#.#...#.#.#...#...#...#.#.......#  
  #.###.#######.###.###.#.###.###.#.#######  
  #...#.......#.#...#...#.............#...#  
  #.#########.#######.#.#######.#######.###  
  #...#.#    F       R I       Z    #.#.#.#  
  #.###.#    D       E C       H    #.#.#.#  
  #.#...#                           #...#.#  
  #.###.#                           #.###.#  
  #.#....OA                       WB..#.#..ZH
  #.###.#                           #.#.#.#  
CJ......#                           #.....#  
  #######                           #######  
  #.#....CK                         #......IC
  #.###.#                           #.###.#  
  #.....#                           #...#.#  
  ###.###                           #.#.#.#  
XF....#.#                         RF..#.#.#  
  #####.#                           #######  
  #......CJ                       NM..#...#  
  ###.#.#                           #.###.#  
RE....#.#                           #......RF
  ###.###        X   X       L      #.#.#.#  
  #.....#        F   Q       P      #.#.#.#  
  ###.###########.###.#######.#########.###  
  #.....#...#.....#.......#...#.....#.#...#  
  #####.#.###.#######.#######.###.###.#.#.#  
  #.......#.......#.#.#.#.#...#...#...#.#.#  
  #####.###.#####.#.#.#.#.###.###.#.###.###  
  #.......#.....#.#...#...............#...#  
  #############.#.#.###.###################  
               A O F   N                     
               A A D   M                     
EOS

  let(:input) { A_SAMPLE }

  describe Advent::RecursiveDonut do
    let(:ad) { Advent::RecursiveDonut.new(input) }

    describe "#new" do
      it "instantiates a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "maps start and finish points with no level change" do
        expect(ad.points['AA'].first).to eq([ 9, 2,0])
        expect(ad.points['ZZ'].first).to eq([13,16,0])
      end

      it "maps letter points" do
        expect(ad.points['BC']).to contain_exactly([ 2,  8, 1], [9,  6, -1])
        expect(ad.points['FG']).to contain_exactly([11, 12,-1], [2, 15,  1])
        expect(ad.points['DE']).to contain_exactly([ 6, 10,-1], [2, 13,  1])
      end

      it "creates easy position based lookups to find neighbors" do
        expect(ad.points).to include(
          [2, 8] => [9,6,-1],
          [9, 6] => [2,8, 1],
          [11, 12] => [2,15, 1],
          [2, 15] => [11,12,-1],
        )
      end
    end

    describe "#start_pos" do
      it "finds the start position" do
        expect(ad.start_pos).to eq([9,2,0])
      end
    end

    describe "#end_pos" do
      it "finds the end position" do
        expect(ad.end_pos).to eq([13,16,0])
      end
    end

    context "validation" do
      {
        C_SAMPLE => 26,
        D_SAMPLE => 396,
      }.each do |inp, steps|
        it "produces the correct number of steps (#{steps})" do
          ad = Advent::RecursiveDonut.new(inp)
          # ad.debug!
          # binding.pry
          expect(ad.steps).to eq(steps)
        end
      end
    end
  end
end
