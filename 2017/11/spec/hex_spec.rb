require './hex.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    se,sw,se,sw,sw
    EOS
  }

  describe Advent::Hex do
    let(:ad) { Advent::Hex.new(input) }
    let(:path) { %w(se sw se sw sw) }

    describe "#new" do
      it "inits a list of steps" do
        expect(ad.steps).to eq(%w(se sw se sw sw))
      end
    end

    describe "#follow_path" do
      {
        'n'  => [ 0, 1,-1],
        's'  => [ 0,-1, 1],
        'ne' => [ 1, 0,-1],
        'sw' => [-1, 0, 1],
        'nw' => [-1, 1, 0],
        'se' => [ 1,-1, 0],
      }.each do |step, expected|
        it "returns the proper position #{expected} when following a single step #{step}" do
          expect(ad.follow_path([step])).to eq(expected)
        end
      end

      it "follows a path and yields new coordinates" do
        expect(ad.follow_path(path)).to eq([-1,-2,3])
      end
    end

    describe "#distance" do
      it "returns the distance to a specific grid position" do
        expect(ad.distance([-1,-2,3])).to eq(3)
      end
    end

    context "validation" do
      {
        "ne,ne,ne" => 3,
        "ne,ne,sw,sw" => 0,
        "ne,ne,s,s" => 2,
        "se,sw,se,sw,sw" => 3,
      }.each do |inp, steps|
        it "returns the number of steps away #{steps} a path is #{inp}" do
          ad = Advent::Hex.new(inp)
          pos = ad.follow_path(ad.steps)
          expect(ad.distance(pos)).to eq(steps)
        end
      end
    end
  end
end
