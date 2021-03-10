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
    end

    context "validation" do
    end
  end
end
