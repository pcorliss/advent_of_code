require './tetris.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
    EOS
  }

  describe Advent::Tetris do
    let(:ad) { Advent::Tetris.new(input) }

    describe "#new" do
      it "inits a list of jet pulses" do
        expect(ad.jets.count).to eq(40)
        expect(ad.jets.first).to eq(:>)
      end

      it "inits a jet position" do
        expect(ad.jet_pos).to eq(0)
      end

      it "inits rock pos" do
        expect(ad.rock_pos).to eq(0)
      end

      it "inits a grid" do
        expect(ad.grid).to be_a(Grid)
      end
    end

    describe "#get_next_jet" do
      it "returns the current jet" do
        expect(ad.get_next_jet).to eq(:>)
      end

      it "increments the jet counter" do
        ad.get_next_jet
        expect(ad.jet_pos).to eq(1)
      end

      it "cycles back to zero" do
        40.times { ad.get_next_jet }
        expect(ad.jet_pos).to eq(0)
      end
    end

    describe "#get_next_rock" do
      it "gets a rock" do
        expect(ad.get_next_rock).to eq([[0,0],[1,0],[2,0],[3,0]])
      end

      it "gets a second rock" do
        first_rock = ad.get_next_rock
        expect(ad.get_next_rock).to_not eq(first_rock)
      end

      it "increments the rock counter" do
        ad.get_next_rock
        expect(ad.rock_pos).to eq(1)
      end

      it "cycles back to zero" do
        5.times { ad.get_next_rock }
        expect(ad.rock_pos).to eq(0)
      end
    end

    describe "#add_rock!" do
      it "left edge appears two units from left wall and three units above floor" do
        ad.get_next_rock
        ad.add_rock!
      # -6|   #
      # -5|  ###
      # -4|   #
      # -3| 
      # -2| 
      # -1|
      # 00012345
        expect(ad.current_rock).to eq([[4,-6],[3,-5],[4,-5],[5,-5],[4,-4]])
      end

      it "bottom edge appears three units above the highest rock" do
        ad.grid[3,-1] = '#'
        ad.grid[3,-2] = '#'
        ad.grid[3,-3] = '#'
        ad.get_next_rock
        ad.add_rock!
        expect(ad.current_rock).to eq([[4,-9],[3,-8],[4,-8],[5,-8],[4,-7]])
      end

      it "avoids mutating the rock templates" do
        ad.add_rock!
        expect(Advent::Tetris::ROCKS.first).to eq([[0,0],[1,0],[2,0],[3,0]])
      end
    end

    describe "#rock_fall!" do

      it "gets pushed by a jet of air and falls one unit downward" do
        # Right (x+1) and Down (y+1)
        ad.get_next_rock
        ad.add_rock!
        expect(ad.current_rock).to eq([[4,-6],[3,-5],[4,-5],[5,-5],[4,-4]])
        ad.rock_fall!
        expect(ad.current_rock).to eq([[5,-5],[4,-4],[5,-4],[6,-4],[5,-3]])
      end

      it "hits a wall it won't move horizontally" do
        ad.add_rock!
        ad.rock_fall!
        expect(ad.current_rock).to eq([[4,-3],[5,-3],[6,-3],[7,-3]])
        ad.rock_fall!
        expect(ad.current_rock).to eq([[4,-2],[5,-2],[6,-2],[7,-2]])
      end

      it "hits another block horizontally it won't move horizontally" do
        ad.add_rock!
        expect(ad.current_rock).to eq([[3,-4],[4,-4],[5,-4],[6,-4]])
        ad.grid[7,-4] = '#'
        ad.rock_fall!
        expect(ad.current_rock).to eq([[3,-3],[4,-3],[5,-3],[6,-3]])
      end

      it "if a rock encounters the floor it solidifies" do
        ad.add_rock!
        3.times { ad.rock_fall! }
        expect(ad.current_rock).to eq([[4,-1],[5,-1],[6,-1],[7,-1]])
        # ad.debug!
        ad.rock_fall!
        expect(ad.grid.cells.values_at([3,-1],[4,-1],[5,-1],[6,-1])).to eq(['#','#','#','#']) 
        expect(ad.current_rock.count).to eq(5) # Next Rock
      end

      it "if a rock encounters another rock on downward movement it solidifies" do
        ad.add_rock!
        expect(ad.current_rock).to eq([[3,-4],[4,-4],[5,-4],[6,-4]])
        ad.grid[7,-3] = '#'
        # ad.debug!
        x, x, new_rock = ad.rock_fall!
        expect(ad.grid.cells.values_at([4,-4],[5,-4],[6,-4],[7,-4])).to eq(['#','#','#','#']) 
        expect(ad.current_rock.count).to eq(5) # Next Rock
        expect(new_rock).to be_truthy
      end

      it "returns true if a rock solidifies" do
        ad.add_rock!
        2.times { ad.rock_fall! }
        x, x, new_rock = ad.rock_fall!
        expect(new_rock).to be_falsey
        x, x, new_rock = ad.rock_fall!
        expect(new_rock).to be_truthy
      end
    end

    describe "#tower_height" do
      it "returns the height after 2022 rocks" do
        2022.times { ad.rock! }
        expect(ad.tower_height).to eq(3068)
      end
    end

    describe "#cycle_tower_height" do
      it "returns the tower height computed via cycles" do
        # ad.debug!
        expect(ad.cycle_tower_height(2022)).to eq(3068)
      end

      it "returns the tower height computed via cycles" do
        expect(ad.cycle_tower_height(1000000000000)).to eq(1514285714288)
      end
    end

    describe "#find_cycle" do
      it "returns the cycle size" do
        expect(ad.find_cycle[:size]).to eq(35)
      end

      it "returns the first iteration where the cycle applies" do
        ad.debug!
        expect(ad.find_cycle[:start]).to eq(25)
      end

      it "returns the height at the cycle start" do
        expect(ad.find_cycle[:height]).to eq(43)
      end

      it "returns the full cycle delta list" do
        expect(ad.find_cycle[:cycle]).to include(1,2,3,0,1,1)
      end
    end

    context "validation" do
      let(:two_rocks) {
        <<~EOS
         #  
        ### 
         #  
        ####
        EOS
      }
      it "looks right after two rocks" do
        2.times { ad.rock! }
        expect(ad.grid.render).to include(two_rocks.strip)
      end

      let(:ten_rocks) {
        <<~EOS
            # 
            # 
            ##
        ##  ##
        ######
         ###  
          #   
         #### 
            ##
            ##
            # 
          # # 
          # # 
        ##### 
          ### 
           #  
          ####
        EOS
      }

      it "looks right after ten rocks" do
        10.times { ad.rock! }
        expect(ad.grid.render).to include(ten_rocks.strip)
      end

      # xit "does stuff" do
      #   # Could look for cycles that are repeatable
      #   # Ever increasing window after 1000 iterations
      #   iterations = 1_000
      #   min_cycles = 10
      #   heights = iterations.times.map { ad.rock!;ad.tower_height }
      #   deltas = heights.each_with_index.map do |h, idx|
      #     if idx == 0
      #       0
      #     else
      #       h - heights[idx - 1]
      #     end
      #   end

      #   found_cycle_size = -1
      #   (1..(iterations / min_cycles)).each do |slice_size|
      #     slices = deltas.reverse.each_slice(slice_size).to_a
      #     last_slice = slices.first
      #     found_cycle = slices.first(min_cycles).all? do |s|
      #       last_slice == s
      #     end
      #     if found_cycle
      #       found_cycle_size = slice_size
      #       break
      #     end
      #   end
      #   # Pattern is capture in test data via the following on a wide screen
      #   # deltas.each_slice(35).to_a
      #   binding.pry
      # end

    end
  end
end
