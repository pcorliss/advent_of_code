require './arcade.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    104,1,104,2,104,3,104,6,104,5,104,4,99
    EOS
  }

  describe Advent::Arcade do
    let(:ad) { Advent::Arcade.new(input) }

    describe "#new" do
    end

    describe "#run!" do
      it "fills a grid based on the output" do
        ad.run!
        expect(ad.grid.cells).to eq({
          [1,2] => 3,
          [6,5] => 4,
        })
      end
    end

    context "validation" do
    end
  end
end
