require './shuffle.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
deal with increment 34
deal into new stack
cut 1712
    EOS
  }

  describe Advent::Shuffle do
    let(:ad) { Advent::Shuffle.new(input) }
    let(:big_deck) { 10007.times.to_a }

    describe "#new" do
      it "instantiates a new deck with 10007 cards" do
        expect(ad.deck).to eq(big_deck)
      end

      it "loads instructions" do
        expect(ad.instructions).to eq([
          "deal with increment 34",
          "deal into new stack",
          "cut 1712",
        ])
      end
    end

    describe "#deal_into_new_stack" do
      it "reverses the order" do
        ad.deal_into_new_stack!
        expect(ad.deck.to_a).to eq(big_deck.reverse)
      end
    end

    describe "#deal_with_increment" do
      # The inverse mod only works with prime number deck lengths
      # {
      #   1 => [0,1,2,3,4,5,6,7,8,9],
      #   3 => [0,7,4,1,8,5,2,9,6,3],
      #   7 => [0,3,6,9,2,5,8,1,4,7],
      #   9 => [0,9,8,7,6,5,4,3,2,1],
      # }.each do |offset, expected|
      #   it "skips spaces and wraps around #{offset} gets #{expected}" do
      #     ad = Advent::Shuffle.new(input, 10)
      #     ad.deal_with_increment!(offset)
      #     expect(ad.deck.to_a).to eq(expected)
      #   end
      # end
      {
        3 => [0, 9, 5, 1, 10, 6, 2, 11, 7, 3, 12, 8, 4],
        7 => [0, 2, 4, 6, 8, 10, 12, 1, 3, 5, 7, 9, 11],
        9 => [0, 3, 6, 9, 12, 2, 5, 8, 11, 1, 4, 7, 10],
      }.each do |offset, expected|
        it "skips spaces and wraps around #{offset} gets #{expected}" do
          ad = Advent::Shuffle.new(input, 13)
          ad.deal_with_increment!(offset)
          expect(ad.deck.to_a).to eq(expected)
        end
      end
    end

    describe "#cut" do
      it "rotates the deck by the argument passed" do
        ad = Advent::Shuffle.new(input, 10)
        ad.cut!(3)
        expect(ad.deck.to_a).to eq([3,4,5,6,7,8,9,0,1,2])
      end

      it "rotates the deck by a negative amount" do
        ad = Advent::Shuffle.new(input, 10)
        ad.cut!(-4)
        expect(ad.deck.to_a).to eq([6,7,8,9,0,1,2,3,4,5])
      end
    end

    context "validation" do
      A_SAMPLE = <<~EOS
deal with increment 7
deal into new stack
deal into new stack
      EOS

      B_SAMPLE = <<~EOS
cut 6
deal with increment 7
deal into new stack
      EOS
      C_SAMPLE = <<~EOS
deal with increment 7
deal with increment 9
cut -2
      EOS

      D_SAMPLE = <<~EOS
deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1
      EOS

      # Inverse mod requires a prime deck length
      # {
      #   A_SAMPLE => [0,3,6,9,2,5,8,1,4,7],
      #   B_SAMPLE => [3,0,7,4,1,8,5,2,9,6],
      #   C_SAMPLE => [6,3,0,7,4,1,8,5,2,9],
      #   D_SAMPLE => [9,2,5,8,1,4,7,0,3,6],
      # }.each do |inp, expected|
      #   it "gets the expected result #{expected}" do
      #     ad = Advent::Shuffle.new(inp, 13)
      #     ad.run!
      #     expect(ad.deck.to_a).to eq(expected)
      #   end
      # end

      {
        A_SAMPLE => [0, 2, 4, 6, 8, 10, 12, 1, 3, 5, 7, 9, 11],
        B_SAMPLE => [4, 2, 0, 11, 9, 7, 5, 3, 1, 12, 10, 8, 6],
        C_SAMPLE => [1, 7, 0, 6, 12, 5, 11, 4, 10, 3, 9, 2, 8],
        D_SAMPLE => [11, 7, 3, 12, 8, 4, 0, 9, 5, 1, 10, 6, 2],
      }.each do |inp, expected|
        it "gets the expected result #{expected} with a prime sized deck" do
          ad = Advent::Shuffle.new(inp, 13)
          ad.run!
          expect(ad.deck).to eq(expected)
        end
      end
    end
  end
end
