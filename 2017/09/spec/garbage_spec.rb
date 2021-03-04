require './garbage.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    {{{},{},{{}}},{<a!>},{<a!>},{<a!>},{<ab>}}
    EOS
  }

  describe Advent::Garbage do
    let(:ad) { Advent::Garbage.new(input) }

    describe "#new" do
      it "inits an input string" do
        expect(ad.str).to eq(input.chomp)
      end
    end

    describe "#score" do
      context "garbage chars" do
        context "validation" do
          {
            '<>' => 0,
            '<random characters>' => 17,
            '<<<<>' => 3,
            '<{!>}>' => 2,
            '<!!>' => 0,
            '<!!!>>' => 0,
            '<{o"i!a,<{i<a>' => 10,
          }.each do |inp, expected|
            it "returns the correct result #{expected} for #{inp}" do
              expect(ad.score("{#{inp}}").last).to eq(expected)
            end
          end
        end
      end
      context "scoring" do
        it "handles single groups" do
          expect(ad.score('{}').first).to eq(1)
        end

        it "handles nested groups" do
          expect(ad.score('{{{}}}').first).to eq(6)
        end

        it "handles parallel groups" do
          expect(ad.score('{{},{}}').first).to eq(5)
        end

        it "handles garbage" do
          expect(ad.score('{<a>,<a>,<a>,<a>}').first).to eq(1)
        end

        it "handles bang (!)" do
          expect(ad.score('{{<a!>},{<a!>},{<a!>},{<ab>}}').first).to eq(3)
        end

        context "validation" do
          {
            '{{{},{},{{}}}}' => 16,
            '{{<ab>},{<ab>},{<ab>},{<ab>}}' => 9,
            '{{<!!>},{<!!>},{<!!>},{<!!>}}' => 9,
          }.each do |inp, expected|
            it "returns the correct result #{expected} for #{inp}" do
              expect(ad.score(inp).first).to eq(expected)
            end
          end
        end
      end
    end

    context "validation" do
    end
  end
end
