require './tuning.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
    EOS
  }

  describe Advent::Tuning do
    let(:ad) { Advent::Tuning.new(input) }

    describe "#new" do
      it "loads a string" do
        expect(ad.buffer).to eq("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
      end
    end

    describe "#marker" do
      {
        'mjqjpqmgbljsphdztnvjfqwrcgsmlb' => 7,
        'bvwbjplbgvbhsrlpgdmjqwftvncz' => 5,
        'nppdvjthqldpwncqszvftbrmjlhg' => 6,
        'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg' => 10,
        'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw' => 11,
      }.each do |input, expected|
        it "returns #{expected} when given #{input}" do
          ad = Advent::Tuning.new(input)
          expect(ad.marker).to eq(expected)
        end
      end
    end

    describe "#message_marker" do
      {
        'mjqjpqmgbljsphdztnvjfqwrcgsmlb' => 19,
        'bvwbjplbgvbhsrlpgdmjqwftvncz' => 23,
        'nppdvjthqldpwncqszvftbrmjlhg' => 23,
        'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg' => 29,
        'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw' => 26,
      }.each do |input, expected|
        it "returns #{expected} when given #{input}" do
          ad = Advent::Tuning.new(input)
          expect(ad.message_marker).to eq(expected)
        end
      end
    end

    context "validation" do
    end
  end
end
