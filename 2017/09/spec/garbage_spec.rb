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
      it "handles single groups" do
        expect(ad.score('{}')).to eq(1)
      end

      it "handles nested groups" do
        expect(ad.score('{{{}}}')).to eq(6)
      end

      it "handles parallel groups" do
        expect(ad.score('{{},{}}')).to eq(5)
      end

      it "handles garbage" do
        expect(ad.score('{<a>,<a>,<a>,<a>}')).to eq(1)
      end

      it "handles bang (!)" do
        expect(ad.score('{{<a!>},{<a!>},{<a!>},{<ab>}}')).to eq(3)
      end

      context "validation" do
        {
          '{{{},{},{{}}}}' => 16,
          '{{<ab>},{<ab>},{<ab>},{<ab>}}' => 9,
          '{{<!!>},{<!!>},{<!!>},{<!!>}}' => 9,
        }.each do |inp, expected|
          it "returns the correct result #{expected} for #{inp}" do
            expect(ad.score(inp)).to eq(expected)
          end
        end
      end
    end

    context "validation" do
    end
  end
end
