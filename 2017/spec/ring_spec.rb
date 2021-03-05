require 'rspec'
require 'pry'
require_relative '../lib/ring.rb'

describe Advent do
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
    end

    describe "#to_a" do
      it "returns the list as an array" do
        expect(list.to_a).to eq(5.times.to_a)
      end
    end

    describe "#reverse" do
      it "reverses a section of the linked list" do
        list.reverse(node, 3) # Node 0 and 3 total elements (0, 1, 2)
        # [0, 1, 2, 3, 4] becomes [2, 1, 0, 3, 4]
        expect(list.to_a).to eq([0, 3, 4, 2, 1])
        expect(node.next.val).to eq(3)
        expect(node.prev.val).to eq(1)
        expect(node.prev.prev.prev.val).to eq(4)
        expect(node.next.next.next.val).to eq(2)
      end

      it "handles reversing the entire list" do
        list.reverse(node, 5)
        expect(list.to_a).to eq([0, 4, 3, 2, 1])
        expect(node.next.val).to eq(4)
        expect(node.prev.val).to eq(1)
        expect(node.next.prev).to eq(node)
        expect(node.prev.next).to eq(node)
      end

      [
        [0, 1, 2, 3, 4],
        [0, 1, 2, 3, 4],
        [0, 2, 3, 4, 1],
        [0, 3, 4, 2, 1],
        [0, 4, 3, 2, 1],
        [0, 4, 3, 2, 1],
      ].each_with_index do |expected, count|
        it "reverses with a count of #{count}" do
          list.reverse(node, count)
          expect(list.to_a).to eq(expected)
          expect(node.next.prev).to eq(node)
          expect(node.prev.next).to eq(node)
        end
      end
    end
  end
end
