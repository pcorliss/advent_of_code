require './spinlock.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    3
    EOS
  }

  describe Advent::Spinlock do
    let(:ad) { Advent::Spinlock.new(input) }

    describe "#new" do
      it "inits a skip length" do
        expect(ad.skip).to eq(3)
      end

      it "inits a ring buffer with a zero node" do
        expect(ad.ring.length).to eq(1)
        expect(ad.ring.first.val).to eq(0)
      end
    end

    describe "#step!" do
      it "adds an element (1) to the buffer" do
        ad.step!
        expect(ad.ring.length).to eq(2)
        expect(ad.ring.first.next.val).to eq(1)
      end

      it "increments the counter each time and applies skips" do
        3.times { ad.step! }
        expect(ad.ring.length).to eq(4)
        expect(ad.ring.to_a).to eq([0, 2, 3, 1])
        6.times { ad.step! }
        expect(ad.ring.to_a).to eq([0, 9, 5, 7, 2, 4, 3, 8, 6, 1])
      end

      it "returns the current_node" do
        expect(ad.step!.val).to eq(1)
      end
    end

    describe "#fake_step!" do
      it "doesn't add an element but does increment values" do
        ad.fake_step!
        expect(ad.length).to eq(2)
        expect(ad.last_val).to eq(1)
        expect(ad.pos).to eq(1)
      end

      it "keeps track of values next to zero" do
        ad.fake_step!
        expect(ad.val_next).to eq(1)
        ad.fake_step!
        expect(ad.val_next).to eq(2)
        ad.fake_step!
        ad.fake_step!
        expect(ad.val_next).to eq(2)
        ad.fake_step!
        expect(ad.val_next).to eq(5)
      end
    end

    context "validation" do
      it "yields the proper value after 2017" do
        ad.debug!
        2016.times { ad.step! }
        node = ad.step!
        expect(node.next.val).to eq(638)
      end

      it "yields the proper next_val 2017" do
        ad.debug!
        2017.times { ad.fake_step! }
        expect(ad.val_next).to eq(1226)
      end
    end
  end
end
