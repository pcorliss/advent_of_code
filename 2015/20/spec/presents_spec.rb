require './presents.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Presents do
    let(:ad) { Advent::Presents.new(input) }

    describe "#new" do
    end

    describe "#presents" do
      {
        1 => 10,
        2 => 30,
        3 => 40,
        4 => 70,
        5 => 60,
        6 => 120,
        7 => 80,
        8 => 150,
        9 => 130,
        100 => 2_170,
        1_000 => 23_400,
        10_000 => 242_110,
        # 100_000 => 2_460_780,
        # 1_000_000 => 24_804_370,
        # 10_000_000 => 249_022_800,
      }.each do |house, presents|
        it "returns the number of presents, #{presents},  delivered to the passed house number, #{house}" do
          expect(ad.presents(house)).to eq(presents)
        end
      end
    end

    describe "#find_house" do
      {
        10 =>        1,
        30 =>        2,
        40 =>        3,
        70 =>        4,
        60 =>        4,
        120 =>       6,
        80 =>        6,
        150 =>       8,
        130 =>       8,
        1560 =>      60,
        # 10_000 =>    360,
        # 100_000 =>   3_120,
        # 1_000_000 => 27_720,
      }.each do |presents, house|
        it "returns the lowest house number, #{house}, for the number of presents passed, #{presents}" do
          # ad.debug!
          expect(ad.find_house(presents)).to eq(house)
        end
      end
    end

    describe "#find_house_prime" do
      {
        10 =>        1,
        # 30 =>        2,
        40 =>        3,
        70 =>        4,
        60 =>        4,
        120 =>       6,
        80 =>        6,
        150 =>       8,
        130 =>       8,
        1560 =>      60,
        # 10_000 =>    360,
        # 100_000 =>   3_120,
        # 1_000_000 => 27_720,
      }.each do |presents, house|
        it "returns the lowest house number, #{house}, for the number of presents passed, #{presents}" do
          # ad.debug!
          expect(ad.find_house_prime(presents)).to eq(house)
        end
      end
    end

    context "validation" do
    end
  end
end
