require '../bus.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    939
    7,13,x,x,59,x,31,19
    EOS
  }

  describe Advent::Bus do
    let(:ad) { Advent::Bus.new(input) }

    describe "#new" do
      it "sets a start time" do
        expect(ad.start).to eq(939)
      end

      it "sets a collection of busses" do
        expect(ad.bus).to eq([7, 13, 59, 31, 19])
      end
    end

    describe "#earliest_bus" do
      it "returns the earliest bus id and the time until it arrives" do
        expect(ad.earliest_bus).to eq([59, 5])
      end
    end

    describe "#contest_match?" do
      it "Matches on multiples" do
        ad = Advent::Bus.new("0\n7,13,x,x,59,x,31,19")
        expect(ad.contest_match?(1068781)).to be_truthy
        # ad = Advent::Bus.new("0\n7,13,x,x,59,x,31,x")
        # expect(ad.contest_match?(1068781)).to be_truthy
        expect(1068781 % 7).to eq(0)
        expect(1068781 % 13).to eq(13 - 1)
        expect(1068781 % 59).to eq(59 - 4)
        expect(1068781 % 31).to eq(31 - 6)
        expect(1068781 % 19).to eq(19 - 7)

        ad = Advent::Bus.new("0\nx,7,3,x,x,x,11")
        # Adding LCM (7*3*11) will always be truthy
        expect(ad.contest_match?(181)).to be_truthy
        expect(ad.contest_match?(412)).to be_truthy
        expect(ad.contest_match?(643)).to be_truthy
        expect(ad.contest).to eq(181)
      end
    end

    describe "#contest_prime" do
      it "solves for single elements" do
        # ad = Advent::Bus.new("0\nx,7,3,x,x,x,11")
        expect(ad.contest_prime({7 => 1})).to eq(6)
      end

      it "solves for two elements" do
        expect(ad.contest_prime({11 => 6, 7 => 1})).to eq(27)
      end

      it "solves for three elements" do
        # ad = Advent::Bus.new("0\nx,7,3,x,x,x,11")
        expect(ad.contest_prime({11 => 6, 7 => 1, 3 => 2})).to eq(181)
      end
    end

    context "validation" do
      {
        "17,x,13,19" => 3417,
        "67,7,59,61" => 754018,
        "67,x,7,59,61" => 779210,
        "7,13,x,x,59,x,31,19" => 1068781,
        "67,7,x,59,61" => 1261476,
        "1789,37,47,1889" => 1_202_161_486,
        "x,7,3,x,x,x,11" => 181,
      }.each do |inp, expected|
        it "validates that #{inp} returns #{expected}" do
          ad = Advent::Bus.new("0\n#{inp}")
          expect(ad.contest).to eq(expected)
        end
      end
    end
  end
end
