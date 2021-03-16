require './virus.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      ..#
      #..
      ...
    EOS
  }

  describe Advent::Virus do
    let(:ad) { Advent::Virus.new(input) }

    describe "#new" do
      it "inits a sparse grid" do
        expect(ad.grid).to be_a(Grid)
        expect(ad.grid[2,0]).to eq('#')
        expect(ad.grid[0,1]).to eq('#')
        expect(ad.grid.cells.count).to eq(2)
      end

      it "inits a pos in the center of the passed grid" do
        expect(ad.pos).to eq([1,1])
      end

      it "inits a direction pointing North [0, -1]" do
        expect(ad.dir).to eq([0,-1])
      end
    end

    describe "#burst!" do
      it "If the current node is infected, it turns to its right." do
        ad.grid[ad.pos] = '#'
        ad.burst!
        expect(ad.dir).to eq([1,0])
      end

      it "If the current node is clean it turns to its left." do
        ad.burst!
        expect(ad.dir).to eq([-1,0])
      end

      it "If the current node is clean, it becomes infected." do
        ad.burst!
        expect(ad.grid[1,1]).to eq('#')
      end

      it "If the current node is infected, it becomes cleaned." do
        ad.grid[ad.pos] = '#'
        ad.burst!
        expect(ad.grid[1,1]).to be_nil
      end

      it "The virus carrier moves forward one node in the direction it is facing." do
        ad.burst!
        expect(ad.pos).to eq([0,1])
      end

      it "returns true if a burst caused an infection" do
        expect(ad.burst!).to be_truthy
      end

      it "returns false if a burst didn't cause an infection" do
        ad.grid[ad.pos] = '#'
        expect(ad.burst!).to be_falsey
      end

      context "weakened" do
        it "Clean nodes become weakened." do
          ad.burst!(weakened: true)
          expect(ad.grid[1,1]).to eq('W')
        end

        it "Weakened nodes become infected." do
          ad.grid[ad.pos] = 'W'
          ad.burst!(weakened: true)
          expect(ad.grid[1,1]).to eq('#')
        end

        it "Infected nodes become flagged." do
          ad.grid[ad.pos] = '#'
          ad.burst!(weakened: true)
          expect(ad.grid[1,1]).to eq('F')
        end

        it "Flagged nodes become clean." do
          ad.grid[ad.pos] = 'F'
          ad.burst!(weakened: true)
          expect(ad.grid[1,1]).to be_nil
        end

        it "If it is clean, it turns left." do
          ad.grid[ad.pos] = nil
          ad.burst!(weakened: true)
          expect(ad.dir).to eq([-1,0])
          expect(ad.pos).to eq([0,1])
        end

        it "If it is weakened, it does not turn, and will continue moving in the same direction." do
          ad.grid[ad.pos] = 'W'
          ad.burst!(weakened: true)
          expect(ad.dir).to eq([0,-1])
          expect(ad.pos).to eq([1,0])
        end

        it "If it is infected, it turns right." do
          ad.grid[ad.pos] = '#'
          ad.burst!(weakened: true)
          expect(ad.dir).to eq([1,0])
          expect(ad.pos).to eq([2,1])
        end

        it "If it is flagged, it reverses direction, and will go back the way it came." do
          ad.grid[ad.pos] = 'F'
          ad.burst!(weakened: true)
          expect(ad.dir).to eq([0,1])
          expect(ad.pos).to eq([1,2])
        end

        it "returns true if a burst caused an infection" do
          ad.grid[ad.pos] = 'W'
          expect(ad.burst!(weakened: true)).to be_truthy
        end

        it "returns false if a burst didn't cause an infection" do
          ad.grid[ad.pos] = nil
          expect(ad.burst!(weakened: true)).to be_falsey
        end
      end
    end

    describe "#run!" do
      it "runs burst n times and returns the count of infections" do
        expect(ad.run!(7)).to eq(5)
      end
    end

    context "validation" do
      it "After a total of 70 bursts of activity, 41 bursts will have caused an infection." do
        expect(ad.run!(70)).to eq(41)
      end
      it "After a total of 10000 bursts of activity, 5587 bursts will have caused an infection." do
        expect(ad.run!(10_000)).to eq(5_587)
      end

      context "weakened" do 
        it "does the right thing" do
          # ad.debug!
          count = ad.run!(10, weakened: true)
          expect(count).to eq(1)
        end

        it "After a total of 100 bursts of activity, 26 bursts will have caused an infection." do
          expect(ad.run!(100, weakened: true)).to eq(26)
        end

        xit "After a total of 10000000 bursts of activity, 2511944 bursts will have caused an infection." do
          expect(ad.run!(10_000_000, weakened: true)).to eq(2_511_944)
        end
      end
    end
  end
end
