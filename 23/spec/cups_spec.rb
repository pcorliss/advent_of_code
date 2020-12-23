require '../cups.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    389125467
    EOS
  }

  describe Advent::Cups do
    let(:ad) { Advent::Cups.new(input) }

    describe "#new" do
      it "inits a new sequence" do
        expect(ad.current_pos).to eq(0)
        expect(ad.cups).to eq([3,8,9,1,2,5,4,6,7])
      end
    end

    describe "#move!" do
      it "increments the current cup" do
        expect(ad.current_pos).to eq(0)
        expect(ad.cups[ad.current_pos]).to eq(3)
        ad.move!
        expect(ad.current_pos).to eq(1)
        expect(ad.cups[ad.current_pos]).to eq(2)
      end

      it "moves three cups to a new position" do
        expect(ad.cups).to eq([3,8,9,1,2,5,4,6,7])
        ad.move!
        expect(ad.cups).to eq([3,2,8,9,1,5,4,6,7])
      end

      it "keeps subtracting until it finds a destination of a cub just picked up" do
        expect(ad.cups).to eq([3,8,9,1,2,5,4,6,7])
        ad.move!
        expect(ad.cups).to eq([3,2,8,9,1,5,4,6,7])
        ad.move!
        expect(ad.cups).to eq([3,2,5,4,6,7,8,9,1])
      end
    end

    context "validation" do
      it "results in valid sequences after each move" do
        expect(ad.cups).to eq([3,8,9,1,2,5,4,6,7])
        ad.move!
        expect(ad.cups).to eq([3,2,8,9,1,5,4,6,7])
        ad.move!
        expect(ad.cups).to eq([3,2,5,4,6,7,8,9,1])
        ad.move!
        expect(ad.cups).to eq([7,2,5,8,9,1,3,4,6])
        ad.move!
        expect(ad.cups).to eq([3,2,5,8,4,6,7,9,1])
        ad.move!
        expect(ad.cups).to eq([9,2,5,8,4,1,3,6,7])
        ad.move!
        expect(ad.cups).to eq([7,2,5,8,4,1,9,3,6])
        ad.move!
        expect(ad.cups).to eq([8,3,6,7,4,1,9,2,5])
        ad.move!
        expect(ad.cups).to eq([7,4,1,5,8,3,9,2,6])
        ad.move!
        expect(ad.cups).to eq([5,7,4,1,8,3,9,2,6])
        ad.move!
        expect(ad.cups).to eq([5,8,3,7,4,1,9,2,6])
        ad.move!
      end

      it "delivers the correct ordering after 100 moves" do
        100.times { ad.move! }
        expect(ad.cups_starting_from_1).to eq([6,7,3,8,4,5,2,9])
      end
    end
  end
end
