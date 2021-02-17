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
        8.times { puts ad.elves.render(ad.current_elf); ad.step_across! }
        expect(ad.current_elf.val).to eq(2)
        expect(ad.current_elf.next).to eq(ad.current_elf)
        expect(ad.current_elf.prev).to eq(ad.current_elf)
      end
    end

    context "validation" do
    end
  end

  describe Advent::CircularLinkedList do
    let(:list) { Advent::CircularLinkedList.new(5.times) }
    let(:node) { list.first }

    describe "#new" do
      it "inits a linked list with the passed values" do
        expect(node.val).to eq(0)
      end

      it "links to the next element in the list" do
        expect(node.next.val).to eq(1)
      end

      it "the last element links back to first element" do
        expect(node.next.next.next.next.next.next.val).to eq(1)
      end

      it "the first element links back to the last element" do
        expect(node.prev.val).to eq(4)
      end

      it "maintains a length" do
        expect(list.length).to eq(5)
      end
    end

    describe "#init_cross" do
      it "populates the cross circle pointers" do
        list.init_cross!
        expect(node.cross).to eq(node.next.next)
        expect(node.cross.rev_cross).to eq(node)
      end
    end

    describe "#destroy" do
      it "resets the next element" do
        prev_node = node
        to_destroy = node.next
        next_node = node.next.next
        list.destroy(to_destroy)
        expect(prev_node.next).to eq(next_node)
      end

      it "resets the prev element" do
        prev_node = node
        to_destroy = node.next
        next_node = node.next.next
        list.destroy(to_destroy)
        expect(next_node.prev).to eq(prev_node)
      end

      it "decrements the length" do
        list.destroy(node)
        expect(list.length).to eq(4)
      end

      context "cross attrs" do
        before do 
          list.init_cross!
        end

        it "updates the cross attr" do
          cross = node.cross
          expected_cross = cross.next
          list.destroy(cross)
          expect(node.cross).to eq(expected_cross)
        end
      end
    end
  end
end
