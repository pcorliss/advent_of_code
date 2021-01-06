require './maze.rb'
require 'rspec'
require 'pry'

describe Advent do

  describe Advent::Maze do
    let(:input) {
      <<~EOS
  ########################
  #f.D.E.e.C.b.A.@.a.B.c.#
  ######################.#
  #d.....................#
  ########################
      EOS
    }
    let(:ad) { Advent::Maze.new(input) }

    describe "#new" do
      it "constructs a grid" do
        expect(ad.grid).to be_a(Grid)
      end

      it "inits paths" do
        expect(ad.paths).to eq([{
          pos: [15,1],
          visited: Set.new([[15,1]]),
          keys: Set.new,
        }])
      end
    end

    describe "#starting_location" do
      it "returns the starting location" do
        expect(ad.starting_location).to eq([15,1])
      end
    end

    describe '#keys' do
      it "returns a set of all keys in the maze" do
        expected = %w(a b c d e f)
        expect(ad.keys).to contain_exactly(*expected)
      end
    end

    describe "#move!" do
      it "increments the counter" do
        expect { ad.move! }.to change { ad.steps }.by(1)
      end

      it "moves one step in all possible directions" do
        expect(ad.move!).to contain_exactly(
          {pos: [14,1], keys: Set.new},
          {pos: [16,1], keys: Set.new},
        )
      end

      it "excludes paths that have already been visited and those with locked doors" do 
        2.times { ad.move! }
        expect(ad.paths.count).to eq(1)
        expect(ad.paths.first[:pos]).to eq([17,1])
      end

      it "picks up keys" do
        2.times { ad.move! }
        expect(ad.paths.map { |p| p[:keys] }).to include(Set.new(["a"]))
      end

      it "allows backtracking if we have a new key (blow away visited set)" do
        3.times { ad.move! }
        expect(ad.paths.map {|p| p[:pos]}).to include([16,1])
      end

      it "goes through doors if we have the right key" do
        6.times { ad.move! }
        expect(ad.paths.count).to eq(1)
        expect(ad.paths.first[:pos]).to eq([13,1])
      end
    end

    describe "#finished?" do
      it "returns false" do
        expect(ad.finished?).to be_falsey
      end

      it "returns true if all the keys have been found in one of the paths" do
        85.times { ad.move! }
        expect(ad.finished?).to be_falsey
        ad.move!
        expect(ad.finished?).to be_truthy
      end
    end

    describe "#steps_until_finished" do
      it "it returns an integer of the number of steps to achieve a finished state" do
        expect(ad.steps_until_finished).to eq(86)
      end
    end

    context "validation" do
      A_SAMPLE = <<~EOS
#########
#b.A.@.a#
#########
    EOS

      B_SAMPLE = <<~EOS
########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################
    EOS

      D_SAMPLE = <<~EOS
########################
#@..............ac.GI.b#
###d#e#f################
###A#B#C################
###g#h#i################
########################
    EOS

      E_SAMPLE = <<~EOS
########################
#f.D.E.e.C.b.A.@.a.B.c.#
######################.#
#d.....................#
########################
    EOS
      C_SAMPLE = <<~EOS
#################
#i.G..c...e..H.p#
########.########
#j.A..b...f..D.o#
########@########
#k.E..a...g..B.n#
########.########
#l.F..d...h..C.m#
#################
    EOS

      {
        A_SAMPLE => 8,
        B_SAMPLE => 132,
        D_SAMPLE => 81,
        E_SAMPLE => 86,
        # C_SAMPLE => 136,
      }.each do |inp, steps|
        it "calculates the number of steps to gather all keys at #{steps}" do
          ad = Advent::Maze.new(inp)
          # ad.debug!
          expect(ad.steps_until_finished).to eq(steps)
        end
      end
    end
  end
  describe Advent::MultiMaze do
    let(:ad) { Advent::MultiMaze.new(input) }
    let(:input) { INPUT }

    INPUT = <<~EOS
    #######
    #a.#Cd#
    ##@#@##
    #######
    ##@#@##
    #cB#Ab#
    #######
    EOS
    # 8 steps

    F_SAMPLE = <<~EOS
    ###############
    #d.ABC.#.....a#
    ######@#@######
    ###############
    ######@#@######
    #b.....#.....c#
    ###############
    EOS
    # 24 steps

    G_SAMPLE = <<~EOS
    #############
    #DcBa.#.GhKl#
    #.###@#@#I###
    #e#d#####j#k#
    ###C#@#@###J#
    #fEbA.#.FgHi#
    #############
    EOS
    # 32 steps

    H_SAMPLE = <<~EOS
    #############
    #g#f.D#..h#l#
    #F###e#E###.#
    #dCba@\#@BcIJ#
    #############
    #nK.L@\#@G...#
    #M###N#H###.#
    #o#m..#i#jk.#
    #############
    EOS
    # 72 steps

    describe "#map" do
      it "returns a map" do
        expect(ad.map).to be_a(Hash)
      end

      it "maps starting locations to different sections" do
        expect(ad.map.keys).to include(0,1,2,3)
      end

      it "maps distances to keys" do
        expect(ad.map[0][0]['a'][:distance]).to eq(2)
      end

      it "maps requirements for keys" do
        expect(ad.map[0][0]['a'][:requirements]).to be_empty
        expected = Bitset.new(26)
        expected.set('c'.ord - 97)
        expect(ad.map[1][1]['d'][:requirements]).to eq(expected)
      end

      context "more complexity" do
        let(:ad) { Advent::MultiMaze.new(G_SAMPLE) }
        it "maps key-to-key distances" do
          expect(ad.map[1]['l']['j'][:distance]).to eq(4)
          expected = Bitset.new(26)
          expected.set(('i'.ord - 97),('k'.ord - 97))
          expect(ad.map[1]['l']['j'][:requirements]).to eq(expected)
        end

        it "maps the reverse" do
          expect(ad.map[1]['j']['l'][:distance]).to eq(4)
          expected = Bitset.new(26)
          expected.set(('i'.ord - 97),('k'.ord - 97))
          expect(ad.map[1]['j']['l'][:requirements]).to eq(expected)
        end
      end

      describe "bfs" do
        it "returns an array with each step and distance" do
          # ad.debug!
          expect(ad.bfs).to eq([
            [0, "a", 2],
            [3, "b", 2],
            [2, "c", 2],
            [1, "d", 2],
          ])
        end
      end

      context "validation" do
        {
          # INPUT => 8,
          # F_SAMPLE => 24,
          # G_SAMPLE => 32,
          H_SAMPLE => 72,
        }.each do |inp, steps|
          it "finds the correct step count #{steps} for the given input" do
            ad = Advent::MultiMaze.new(inp)
            ad.debug!
            expect(ad.bfs.map {|s| s[2] }.sum).to eq(steps)
          end
        end
      end
    end
  end
end
