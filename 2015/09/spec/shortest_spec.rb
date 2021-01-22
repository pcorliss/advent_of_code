require './shortest.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
    EOS
  }

  describe Advent::Shortest do
    let(:ad) { Advent::Shortest.new(input) }

    describe "#new" do
      it "inits point-to-point distances" do
        expect(ad.distance['London']['Dublin']).to eq(464)
      end

      it "inits the reverse map" do 
        expect(ad.distance['Dublin']['London']).to eq(464)
      end
    end

    describe "#shortest" do
      it "returns the shortest path" do
        expect(ad.shortest).to eq(
          path: ['London','Dublin','Belfast'],
          distance: 605,
        )
      end
    end

    describe "#longest" do
      it "returns the longest path" do
        expect(ad.longest).to eq(
          path: ['Dublin', 'London', 'Belfast'],
          distance: 982,
        )
      end
    end

    context "validation" do
    end
  end
end
