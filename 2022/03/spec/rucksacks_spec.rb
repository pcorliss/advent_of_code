require './rucksacks.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
    EOS
  }

  describe Advent::Rucksacks do
    let(:ad) { Advent::Rucksacks.new(input) }

    describe "#new" do
      it "loads rucksacks" do
        expect(ad.sacks.length).to eq(6)
      end
    end

    describe "#common" do
      it "returns the common item" do
        expect(ad.common(ad.sacks[0])).to eq('p')
      end

      ['p', 'L', 'P', 'v', 't', 's'].each_with_index do |item, idx|
        it "returns #{item} for sack #{idx}" do
          expect(ad.common(ad.sacks[idx])).to eq(item)
        end
      end
    end

    describe "#priority_sum" do
      it "returns the total priority" do
        expect(ad.priority_sum).to eq(157)
      end
    end

    describe "#common_group_item" do
      ['r','Z'].each_with_index do |item, idx|
        it "returns #{item} for 3 sack group #{idx}" do
          expect(ad.common_group_item(
            ad.sacks[idx*3], 
            ad.sacks[idx*3 + 1], 
            ad.sacks[idx*3 + 2], 
          )).to eq(item)
        end
      end
    end

    describe "#priority_sum_groups" do
      it "returns the total priority" do
        expect(ad.priority_sum_groups).to eq(70)
      end
    end
  end
end
