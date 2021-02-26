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
  end
end
