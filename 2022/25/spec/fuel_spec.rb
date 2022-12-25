require './fuel.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
    EOS
  }

  describe Advent::Fuel do
    let(:ad) { Advent::Fuel.new(input) }

    describe "#new" do
      it "loads the input lines" do
        expect(ad.lines.count).to eq(13)
      end
    end

    context "conversions" do
      {
        1 => '1',
        2 => '2',
        3 => '1=',
        4 => '1-',
        5 => '10',
        6 => '11',
        7 => '12',
        8 => '2=',
        9 => '2-',
        10 => '20',
        15 => '1=0',
        20 => '1-0',
        25 => '100',
        2022 => '1=11-2',
        12345 => '1-0---0',
        314159265 => '1121-1110-1=0',
        1747 => '1=-0-2',
        906 => '12111',
        198 => '2=0=',
        11 => '21',
        201 => '2=01',
        31 => '111',
        1257 => '20012',
        32 => '112',
        353 => '1=-1=',
        107 => '1-12',
        7 => '12',
        3 => '1=',
        37 => '122',
      }.each do |decimal, snafu|
        it "#{snafu} snafu to #{decimal} decimal" do
          expect(ad.convert_snafu(snafu)).to eq(decimal)
        end

        it "#{decimal} decimal to #{snafu} snafu" do
          expect(ad.convert_decimal(decimal)).to eq(snafu)
        end
      end

      {
        # Base
        125 => '1000',
        25 => '100',
        5 => '10',

        # Additive
        6 => '11',
        7 => '12',
        31 => '111',

        # Subtractive
        24 => '10-',
        8 => '2=',
        9 => '2-',

        # # Difficult
        198 => '2=0=',
        2022 => '1=11-2',
        201 => '2=01',
      }.each do |decimal, snafu|
        it "#{decimal} decimal to #{snafu} snafu" do
          # ad.debug! if decimal == 201
          expect(ad.convert_decimal(decimal)).to eq(snafu)
        end
      end
    end

    describe "#code" do
      it "returns the code for the input in snafu" do
        expect(ad.code).to eq('2=-1=0')
      end
    end

    context "validation" do
    end
  end
end
