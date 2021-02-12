require './vault.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    hijkl
    EOS
  }

  describe Advent::Vault do
    let(:ad) { Advent::Vault.new(input) }

    describe "#new" do
      it "inits a pw" do
        expect(ad.pw).to eq('hijkl')
      end
    end

    describe "interpret_hash" do
      it "returns an array of the Up, Down, Left, and Right status of the doors where open is true and closed is false" do
        expect(ad.interpret_hash('ced9')).to eq([true, true, true, false])
      end
    end

    describe "#available_directions" do
      it "returns available directions as an array of U D L or R" do
        expect(ad.available_directions([])).to contain_exactly(*%w(U D L))
      end
    end

    describe "#pos" do
      it "returns the current position given a path" do
        expect(ad.pos(%w(U U U D D D L L L R R R))).to eq([0,0])
        expect(ad.pos([])).to eq([0,0])
      end
    end

    describe "#reached_target?" do
      it "returns false" do
        expect(ad.reached_target?([0,0])).to be_falsey
      end

      it "returns true if reached [3,3]" do
        expect(ad.reached_target?([3,3])).to be_truthy
      end
    end

    describe "#out_of_bounds?" do
      it "returns false" do
        expect(ad.reached_target?([0,0])).to be_falsey
      end

      [
        [-1,0], [0,-1],
        [ 4,0], [0, 4],
        [ 4,4]
      ].each do |pos|
        it "returns true because #{pos} is out of bounds of the 4x4 grid" do
          expect(ad.out_of_bounds?(pos)).to be_truthy
        end
      end
    end

    describe "#find_path" do
      {
        'ihgpwlah' => 'DDRRRD',
        'kglvqrro' => 'DDUDRLRRUDRD',
        'ulqzkmiv' => 'DRURDRUDDLLDLUURRDULRLDUUDDDRR',
      }.each do |pw, expected|
        it "finds the shortest path #{expected} given a password #{pw}" do
          ad =Advent::Vault.new(pw)
          ad.debug!
          expect(ad.find_path).to eq(expected)
        end
      end

      {
        'ihgpwlah' => 370,
        'kglvqrro' => 492,
        'ulqzkmiv' => 830,
      }.each do |pw, expected|
        it "finds the longest path #{expected} given a password #{pw}" do
          ad =Advent::Vault.new(pw)
          ad.debug!
          expect(ad.find_path(false).map(&:length).max).to eq(expected)
        end
      end
    end

    context "validation" do
    end
  end
end
