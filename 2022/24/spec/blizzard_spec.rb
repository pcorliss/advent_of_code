require './blizzard.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    #.######
    #>>.<^<#
    #.<..<<#
    #>v.><>#
    #<^v^^>#
    ######.#
    EOS
  }

  describe Advent::Blizzard do
    let(:ad) { Advent::Blizzard.new(input) }

    describe "#new" do
      it "inits a grid" do
        expect(ad.grid[0,0]).to eq('#')
        expect(ad.grid[1,1]).to eq('>')
      end

      it "inits an expedition" do
        expect(ad.exp).to eq([1,0])
      end

      it "inits a goal" do
        expect(ad.goal).to eq([6,5])
      end

      it "inits blizzards" do
        expect(ad.blizzards.count).to eq(19)
        expect(ad.blizzards.first).to eq([[1,1], '>'])
      end
    end

    describe "#tick" do
      it "gets the state of the board at a given minute" do
        expected = <<~EOS
        #.######
        #.>3.<.#
        #<..<<.#
        #>2.22.#
        #>v..^<#
        ######.#
        EOS
        expect(ad.tick(1).render).to eq(expected.strip)
      end

      it "calcs previous minutes" do
        expected = <<~EOS
        #.######
        #<^<22.#
        #.2<.2.#
        #><2>..#
        #..><..#
        ######.#
        EOS
        expect(ad.tick(3).render).to eq(expected.strip)
      end
    end

    describe "#solve" do
      it "returns the number of steps to get to the goal" do
        ad.debug!
        expect(ad.solve).to eq(18)
      end

      it "takes an optional minute, goal, and start" do
        ad.debug!
        expect(ad.solve(18, ad.goal, ad.exp)).to eq(23 + 18)
      end

      it "solves the third leg of the trip" do
        ad.debug!
        expect(ad.solve(23 + 18, ad.exp, ad.goal)).to eq(23 + 18 + 13)
      end
    end

    context "validation" do
    end
  end
end
