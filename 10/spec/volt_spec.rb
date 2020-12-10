require '../volt.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      16
      10
      15
      5
      1
      11
      7
      19
      6
      12
      4
    EOS
  }

  let(:input2) {
    <<~EOS
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
    EOS
  }

  describe Advent::Volt do
    let(:ad) { Advent::Volt.new(input) }

    describe "#new" do
      it "creates a collection of voltages" do
        expect(ad.volts).to be_a(Array)
        expect(ad.volts.first).to be_a(Integer)
      end
    end

    describe "#count_diffs" do
      it "returns a collection of differences in a chain of voltages" do
        expect(ad.count_diffs).to eq({
          1 => 7,
          3 => 5,
        })
      end

      it "returns a collection of differences in a longer chain of voltages" do
        ad = Advent::Volt.new(input2)
        expect(ad.count_diffs).to eq({
          1 => 22,
          3 => 10,
        })
      end
    end

    context "validation" do
    end
  end
end
