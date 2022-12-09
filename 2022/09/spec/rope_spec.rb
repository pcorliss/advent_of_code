require './rope.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
    EOS
  }

  describe Advent::Rope do
    let(:ad) { Advent::Rope.new(input) }

    describe "#new" do
      it "instantiates a series of instructions" do
        expect(ad.instructions.count).to eq(8)
        expect(ad.instructions.first).to eq([:R, 4])
        expect(ad.instructions.last).to eq([:R, 2])
      end

      it "instantiates a head and tail" do
        expect(ad.head).to eq([0,0])
        expect(ad.tail).to eq([0,0])
      end

      it "instantiats a tracer" do
        expect(ad.tracer).to eq(Set.new([[0,0]]))
      end
    end

    describe "#move!" do
      it "interprets an instruction and moves the head" do
        ad.move!([:R, 4])
        expect(ad.head).to eq([4,0])
      end

      it "does nothing to the tail if adjacent" do
        ad.move!([:R, 1])
        expect(ad.tail).to eq([0,0])
      end

      it "pulls the tail along if not adjacent" do
        ad.move!([:R, 4])
        expect(ad.tail).to eq([3,0])
      end

      it "does nothing if diagonally adjacent" do
        ad.move!([:R, 4])
        ad.move!([:U, 1])
        expect(ad.head).to eq([4,-1])
        expect(ad.tail).to eq([3,0])
      end

      it "the tail moves diagonally" do
        ad.move!([:R, 4])
        ad.move!([:U, 2])
        expect(ad.head).to eq([4,-2])
        expect(ad.tail).to eq([4,-1])
      end

      it "makes it to the correct final position" do
        ad.move_all!
        expect(ad.head).to eq([2,-2])
        expect(ad.tail).to eq([1,-2])
      end

      it "updates the tracer" do
        ad.move!([:R, 4])
        # expect(ad.tracer.count).to eq(3)
        expect(ad.tracer).to include([0,0])
        expect(ad.tracer).to include([1,0])
        expect(ad.tracer).to include([2,0])
      end
    end

    describe "#visited" do
      it "returns the count of visited cells" do
        expect(ad.visited).to eq(13)
      end
    end

    context "validation" do
    end
  end
end
