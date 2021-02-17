require './circle.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    5
    EOS
  }

  describe Advent::Circle do
    let(:ad) { Advent::Circle.new(input) }

    describe "#new" do
      it "inits a circular linked list" do
        elf = ad.elves.first
        expect(elf.val).to eq(1)
        elf = elf.next
        expect(elf.val).to eq(2)
      end

      it "sets the position to the first node" do
        expect(ad.current_elf).to eq(ad.elves.first)
      end
    end

    describe "#step!" do
      it "destroys node 2 and advances position to node 3" do
        ad.step!
        expect(ad.current_elf.val).to eq(3)
        expect(ad.current_elf.prev.val).to eq(1)
      end

      it "does nothing if there are no elves remaining" do
        8.times { ad.step! }
        expect(ad.current_elf.val).to eq(3)
        expect(ad.current_elf.next).to eq(ad.current_elf)
        expect(ad.current_elf.prev).to eq(ad.current_elf)
      end
    end

    describe "#step_across!" do
      it "destroys a node directly across (3) (and slightly to the left)" do
        ad.step_across!
        expect(ad.current_elf.val).to eq(2)
        expect(ad.current_elf.next.val).to eq(4)
      end

      it "increments the cross_elf twice if length is even" do
        expect(ad.cross_elf.val).to eq(3)
        ad.step_across!
        expect(ad.cross_elf.val).to eq(5)
      end

      it "increments the cross_elf once if length is odd" do
        ad.step_across!
        expect(ad.cross_elf.val).to eq(5)
        ad.step_across!
        expect(ad.cross_elf.val).to eq(1)
      end

      it "does nothing if there are no elves remaining" do
        8.times { ad.step_across! }
        expect(ad.current_elf.val).to eq(2)
        expect(ad.current_elf.next).to eq(ad.current_elf)
        expect(ad.current_elf.prev).to eq(ad.current_elf)
      end
    end

    context "validation" do
    end
  end
end
