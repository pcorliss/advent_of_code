require './map.rb'
require 'rspec'
require 'pry'

describe Advent do
  let(:full_input_like_cube) {
    <<~EOS
   a.bb.h
   .A..D.
   c.dd.f
   c.d
   .C.
   e.f
c.ee.f
.B..E.
a.gg.h
a.g
.F.
b.h
   
10R5L5R10L4R5L5
  EOS
  }

  let(:input) {
    <<~EOS
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
    EOS
  }

  describe Advent::Map do
    let(:ad) { Advent::Map.new(input) }

    describe "#new" do
      it "instantiates a grid with the map" do
        expect(ad.grid[8,0]).to eq('.')
        expect(ad.grid[11,0]).to eq('#')
        expect(ad.grid[14,11]).to eq('#')
        expect(ad.grid[15,11]).to eq('.')
      end

      it "loads instructions" do
        expect(ad.instructions).to start_with( 10, :R, 5, :L)
      end

      it "inits a starting position" do
        expect(ad.pos).to eq([8,0])
      end

      it "inits a direction" do
        expect(ad.dir).to eq(:E)
      end

      it "inits a cube direction" do
        expect(ad.cube_dir).to eq(:E)
      end

      it "inits a current cube side" do
        expect(ad.cube_side).to eq(:A)
      end
    end

    describe "#run_instruction" do
      it "moves you forward the number of steps" do
        ad.run_instruction(2)
        expect(ad.pos).to eq([10,0])
      end

      it "doesn't allow movement through walls" do
        ad.run_instruction(3)
        expect(ad.pos).to eq([10,0])
      end

      it "handles wrapping around horizontally" do
        ad.pos = [8,3]
        ad.run_instruction(5)
        expect(ad.pos).to eq([9,3])
      end

      it "handles wrapping around vertically" do
        ad.pos = [5,4]
        ad.dir = :S
        ad.run_instruction(5)
        expect(ad.pos).to eq([5,5])
      end

      it "doesn't move you if there's a wall on the wrapped around side" do
        ad.pos = [0,4]
        ad.dir = :W
        ad.run_instruction(3)
        expect(ad.pos).to eq([0,4])
      end

      it "rotates your direction left" do
        ad.run_instruction(:L)
        expect(ad.dir).to eq(:N)
      end

      it "rotates your direction right" do
        ad.run_instruction(:R)
        expect(ad.dir).to eq(:S)
      end

      it "rotates your direction 360 degrees" do
        4.times { ad.run_instruction(:R) }
        expect(ad.dir).to eq(:E)
      end
    end

    describe "#run_cube_instruction" do
      it "handles simple movement and turns" do
        ad.run_cube_instruction(2)
        ad.run_cube_instruction(:L)
        expect(ad.translate_cube).to eq([[10,0], :N])
      end

      it "handles simple wall blocks" do
        ad.run_cube_instruction(3)
        ad.run_cube_instruction(:L)
        expect(ad.translate_cube).to eq([[10,0], :N])
      end

      it "handles shifting to the next side on a turned cube" do
        # ad.debug!
        ad.run_cube_instruction(1)
        ad.run_cube_instruction(:L)
        ad.run_cube_instruction(2)
        expect(ad.translate_cube).to eq([[2,5], :S])
      end

      it "handles the shift to the upside down side F with proper offset" do
        instructions = [2, :R, 4, :R, 6, :L, 3, :R, 1, :R, :R, 1]
        # ad.debug!
        instructions.each do |inst|
          ad.run_cube_instruction(inst)
        end
        expect(ad.translate_cube).to eq([[4,7], :E])
      end

      it "handles the shift from E to B" do
        instructions = [2, :R, 6, :R, 2, :L, 5, :R, 1]
        ad.debug!
        instructions.each do |inst|
          ad.run_cube_instruction(inst)
        end
        expect(ad.translate_cube).to eq([[4,7], :N])
        instructions = [:R, :R, 1]
        instructions.each do |inst|
          ad.run_cube_instruction(inst)
        end
        expect(ad.translate_cube).to eq([[8,11], :E])
      end
    end

    describe "#run_cube" do
      it "runs all the instructions against the cube" do
        # ad.debug!
        ad.run_cube
        expect(ad.translate_cube).to eq([[6,4], :N])
      end
    end

    describe "#run" do
      it "runs all the instructions" do
        ad.run
        expect(ad.pos).to eq([7,5])
        expect(ad.dir).to eq(:E)
      end
    end

    describe "#password" do
      it "returns the password" do
        ad.run
        expect(ad.password).to eq(6032)
      end

      it "returns the password for the cube" do
        ad.run_cube
        pos, dir = ad.translate_cube
        expect(pos).to eq([6,4])
        expect(dir).to eq(:N)
        expect(ad.password(pos, dir)).to eq(5031)
      end
    end

    describe "cube_side_size" do
      it "returns the side grid dimension" do
        expect(ad.cube_side_size).to eq(4)
      end
    end

    # Test Input
    # ..1.
    # 234.
    # ..56

    # .2.  2 delta_y reversed
    # 316  ^
    # .4.  1

    # left become down 1 -> 3
    # up becomes down 1 -> 2
    # right becomes left 1 -> 6
    # down becomes down 1 -> 4

    # Could we do it with offsets?
    # offset of shift

    # Could we instead build a map of cube transitions and rotations
    # and then map each side to this cube?


    # What about some sort of BFS?
    

    # What about calc the possible translations
    # of all possible folds from any given point?

    # Grid Map for every grid to every other adjacent grid
    # Grid 1 -> direction -> grid and new direction

    # .1
    # 346
    # .5

    # 1 is top, split into a grid
    # Check edges for adjacent grids
    # Translate to a 3D grid?

    #    F
    #    D
    #   ABC
    #    E
    # 


    # Full Input
    # .12
    # .3.
    # 45.
    # 6..

    # Generate a grid for all 6 faces
    # Add adjoining 4 faces to each side with proper orientation
    # When you cross a face boundary, switch to other grid.
    # What about rotations?

    # Map Edge and rotations to each side and just handle the hop live?

    # Probably better to determine edges and rotational translations
    # Then just warp the pos
   
    # OK Create a utopic grid mapping
    # Where any face has the translations to the neighboring grid
    # Define the cardinals on each face
    # Then we can understand the number of turns to make it work
    # We can traverse the grid we load and follow the mappings
    # We can use rotate operations to get things to the proper orientation

    # Need to diagram this on paper
    #        

    describe "#cube_map" do
      context "example input cube map" do
        let(:input) {
          <<~EOS
          a..b
          .A..
          #...
          c..d
  b..aa..cc..d
  ..x..B..#C..
  ..F....#....
  h..gg..ee.#f
          e..ff..d
          .E...#D.
          .#......
          g..hh.#b

      10R5L5R10L4R5L5
          EOS
        }
        it "maps the grid to a cube" do
          # ad.debug!
          expect(ad.cube_side_size).to eq(4)
          expect(ad.cube.count).to eq(6)

          expect(ad.cube[:A][1,1]).to eq('A')
          expect(ad.cube[:B][1,1]).to eq('B')
          expect(ad.cube[:C][1,1]).to eq('C')
          expect(ad.cube[:D][1,1]).to eq('D')
          expect(ad.cube[:E][1,1]).to eq('E')
          expect(ad.cube[:F][1,1]).to eq('F')

          expect(ad.cube[:A][0,0]).to eq('a')
          expect(ad.cube[:B][0,0]).to eq('a')
          expect(ad.cube[:C][0,0]).to eq('c')
          expect(ad.cube[:D][0,0]).to eq('d')
          expect(ad.cube[:E][0,0]).to eq('e')
          expect(ad.cube[:F][0,0]).to eq('g')
        end

      end
      context "input like cube map" do
        let(:input) { full_input_like_cube }
        
        it "maps the grid to a cube" do
          # ad.debug!
          expect(ad.cube_side_size).to eq(3)
          expect(ad.cube.count).to eq(6)
          expect(ad.cube[:A][1,1]).to eq('A')
          expect(ad.cube[:B][1,1]).to eq('B')
          expect(ad.cube[:C][1,1]).to eq('C')
          expect(ad.cube[:D][1,1]).to eq('D')
          expect(ad.cube[:E][1,1]).to eq('E')
          expect(ad.cube[:F][1,1]).to eq('F')

          expect(ad.cube[:A][0,0]).to eq('a')
          expect(ad.cube[:B][0,0]).to eq('a')
          expect(ad.cube[:C][0,0]).to eq('c')
          expect(ad.cube[:D][0,0]).to eq('d')
          expect(ad.cube[:E][0,0]).to eq('e')
          expect(ad.cube[:F][0,0]).to eq('g')
        end
      end
      context "straightforward cube map" do
        let(:input) {
          <<~EOS
   a.b
   .A.
   c.d
a.cc.dd.b
.B..C..D.
g.ee.ff.h
   e.f
   .E.
   g.h
   g.h
   .F.
   a.b
      10R5L5R10L4R5L5
          EOS
        }
        
        it "maps the grid to a cube" do
          # ad.debug!
          expect(ad.cube_side_size).to eq(3)
          expect(ad.cube.count).to eq(6)
          expect(ad.cube[:A][1,1]).to eq('A')
          expect(ad.cube[:B][1,1]).to eq('B')
          expect(ad.cube[:C][1,1]).to eq('C')
          expect(ad.cube[:D][1,1]).to eq('D')
          expect(ad.cube[:E][1,1]).to eq('E')
          expect(ad.cube[:F][1,1]).to eq('F')

          expect(ad.cube[:A][0,0]).to eq('a')
          expect(ad.cube[:B][0,0]).to eq('a')
          expect(ad.cube[:C][0,0]).to eq('c')
          expect(ad.cube[:D][0,0]).to eq('d')
          expect(ad.cube[:E][0,0]).to eq('e')
          expect(ad.cube[:F][0,0]).to eq('g')
        end
      end
    end

    context "#translate_cube" do
      let(:input) { full_input_like_cube }

      before { ad.cube }

      it "translates a cube position and direction for origin" do
        expect(ad.translate_cube(:A, [0,0], :N)).to eq([[3,0], :N])
      end

      it "translates a straightforward rotation" do
        # ad.debug!
        expect(ad.translate_cube(:D, [0,0], :N)).to eq([[6,2], :W])
      end

      it "translates a complicated rotation" do
        # ad.debug!
        expect(ad.translate_cube(:F, [0,2], :N)).to eq([[0,9], :E])
      end
    end

    context "validation" do
      xit "interactive" do
        ad.debug!
        ad.interactive

        # There's an issue between side B side E edges
      end

      context "Full input" do
        let(:input) { File.read('input.txt') }

        it "maps the cube" do
          # ad.debug!
          expect(ad.cube.count).to eq(6)
        end
      end
    end
  end
end
