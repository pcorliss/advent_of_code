require './lava.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {

   #   (2,2,1)

   #
  ###   (2,2,2)
   #

   #    (2,2,3)
   
   #    (2,2,4)

   #
  # #   (2,3,5)
   #

   #    (2,2,6)


    <<~EOS
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
    EOS
  }

  describe Advent::Lava do
    let(:ad) { Advent::Lava.new(input) }

    describe "#new" do
      it "inits a list of cubes" do
        expect(ad.cubes.count).to eq(13)
        expect(ad.cubes.first).to eq([2,2,2])
      end
    end

    describe "exposed_sides" do
      let(:simple) {
        <<~EOS
        1,1,1
        2,1,1
        EOS
      }
      it "returns the number of sides exposed" do
        ad = Advent::Lava.new(simple)
        expect(ad.exposed_sides).to eq(10)
      end

      let(:simple2) {
        <<~EOS
        2,2,2
        1,2,2
        3,2,2
        EOS
      }

      it "returns the number of sides exposed for a 3 cube example" do
        ad = Advent::Lava.new(simple2)
        expect(ad.exposed_sides).to eq(14)
      end

      it "returns the number of sides exposed for a larger example" do
        expect(ad.exposed_sides).to eq(64)
      end
    end

    describe "#interior_sides" do
      it "returns the number of sides exposed to the interior" do
        # ad.debug!
        expect(ad.interior_sides).to eq(6)
      end
    end

    context "validation" do 
      it "yields the correct part 2 answer" do
        expect(ad.exposed_sides - ad.interior_sides).to eq(58)
      end

      let(:large_sample) {
        <<~EOS
        1,1,1
        2,1,1
        3,1,1
        4,1,1
        5,1,1
        6,1,1
        1,2,1
        2,2,1
        3,2,1
        4,2,1
        5,2,1
        6,2,1
        1,3,1
        2,3,1
        3,3,1
        4,3,1
        5,3,1
        6,3,1
        1,1,2
        2,1,2
        3,1,2
        4,1,2
        5,1,2
        6,1,2
        1,2,2
        6,2,2
        1,3,2
        2,3,2
        3,3,2
        4,3,2
        5,3,2
        6,3,2
        1,1,3
        2,1,3
        3,1,3
        4,1,3
        5,1,3
        6,1,3
        1,2,3
        2,2,3
        3,2,3
        4,2,3
        5,2,3
        6,2,3
        1,3,3
        2,3,3
        3,3,3
        4,3,3
        5,3,3
        6,3,3
        EOS
      }

      context "large sample" do
        let(:ad) { Advent::Lava.new(large_sample) }

        it "yields the correct part 1 answer" do
          expect(ad.exposed_sides).to eq(108)
        end

        it "yields the correct part 2 answer" do
          expect(ad.exposed_sides - ad.interior_sides).to eq(90)
        end
      end
    end
  end
end
