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
    let(:ad) { Advent::Cups.new(input, 9, true) }

    describe "#new" do
      it "inits a new sequence" do
        expect(ad.current_pos).to eq(0)
        expect(ad.cups).to eq([3,8,9,1,2,5,4,6,7])
      end

      it "inits a sequence with a fill value" do
        ad = Advent::Cups.new(input, 100)
        expect(ad.cups.count).to eq(100)
        expect(ad.cups[9]).to eq(10)
        expect(ad.cups.last).to eq(100)
        expect(ad.cups.uniq.count).to eq(ad.cups.count)
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
      xit "results in valid sequences after each move" do
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

      def rotate_until_first(num, cups)
        cups = cups.clone
        until cups.first == num do
          cups.rotate!
        end
        cups
      end

      # We stopped maintaining the order so the above method rotates until things are right.
      # A custom matcher would be better
      it "results in valid sequences after each move" do
        expect(rotate_until_first(3,ad.cups)).to eq([3,8,9,1,2,5,4,6,7])
        ad.move!
        expect(rotate_until_first(3,ad.cups)).to eq([3,2,8,9,1,5,4,6,7])
        ad.move!
        expect(rotate_until_first(3,ad.cups)).to eq([3,2,5,4,6,7,8,9,1])
        ad.move!
        expect(rotate_until_first(7,ad.cups)).to eq([7,2,5,8,9,1,3,4,6])
        ad.move!
        expect(rotate_until_first(3,ad.cups)).to eq([3,2,5,8,4,6,7,9,1])
        ad.move!
        expect(rotate_until_first(9,ad.cups)).to eq([9,2,5,8,4,1,3,6,7])
        ad.move!
        expect(rotate_until_first(7,ad.cups)).to eq([7,2,5,8,4,1,9,3,6])
        ad.move!
        expect(rotate_until_first(8,ad.cups)).to eq([8,3,6,7,4,1,9,2,5])
        ad.move!
        expect(rotate_until_first(7,ad.cups)).to eq([7,4,1,5,8,3,9,2,6])
        ad.move!
        expect(rotate_until_first(5,ad.cups)).to eq([5,7,4,1,8,3,9,2,6])
        ad.move!
        expect(rotate_until_first(5,ad.cups)).to eq([5,8,3,7,4,1,9,2,6])
        ad.move!
      end

      it "delivers the correct ordering after 100 moves" do
        100.times { ad.move! }
        expect(ad.cups_starting_from_1).to eq([6,7,3,8,4,5,2,9])
      end

      xit "produces the correct value when filling the array with 1 million values and running ten million moves" do
        ad = Advent::Cups.new(input, 1_000_000)
        # 10_000_000.times do |i|
        10000.times do |i|
          ad.move!
          puts "#{i} Iterations" if i % 100 == 0
        end
        index_of_one = ad.cups.index(1)
        cups = ad.cups.slice((index_of_one + 1)..(index_of_one + 3))
        expect(cups).to eq([934001, 159792])
      end
    end
  end
end
