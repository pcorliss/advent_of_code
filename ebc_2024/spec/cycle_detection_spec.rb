require 'rspec'
require 'pry'
require_relative '../lib/cycle_detection.rb'

describe Advent do
  describe Advent::CycleDetection do
    let(:cd) { described_class.new {|x| x % 5 } }

    describe "#new" do
      it "takes a block as a required argument" do
        expect { described_class.new {|x| x } }.not_to raise_error
      end

      it "raises an error if the block is not provided" do
        expect { described_class.new }.to raise_error(ArgumentError)
      end

      it "inits default options" do
        expect(cd.min_cycle_length).to eq(5)        
        expect(cd.max_cycle_length).to eq(30)
        expect(cd.min_repeats).to eq(3)
      end

      it "takes an optional min_cycle_length option " do
        cd = described_class.new(min_cycle_length: 5) {|x| x }
        expect(cd.min_cycle_length).to eq(5)
      end

      it "takes an optional max_cycle_length option " do
        cd = described_class.new(max_cycle_length: 5) {|x| x }
        expect(cd.max_cycle_length).to eq(5)
      end

      it "takes an optional min_repeats option " do
        cd = described_class.new(min_repeats: 5) {|x| x }
        expect(cd.min_repeats).to eq(5)
      end
    end

    describe "#test_cycle?" do
      it "returns true if the last 3 cycles match" do
        cd.instance_variable_set(:@results, [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5])
        expect(cd.test_cycle?(5)).to be_truthy
      end

      it "returns false if the only two cycles match" do
        cd.instance_variable_set(:@results, [1,2,3,4,5,1,2,3,4,5,1,2,3])
        expect(cd.test_cycle?(5)).to be_falsey
      end

      it "returns false if there is a cycle but the length is wrong" do
        cd.instance_variable_set(:@results, [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5])
        expect(cd.test_cycle?(4)).to be_falsey
      end
    end

    describe "#cycle_finder" do
      it "runs the block until it can find a cycle" do
        expect(cd.cycle_finder).to eq(5)
        expect(cd.cycle_length).to eq(5)
        expect(cd.results).to eq([0,1,2,3,4,0,1,2,3,4,0,1,2,3,4])
        expect(cd.cycle).to eq([0,1,2,3,4])
        expect(cd.cycle_first_index).to eq(0)
      end

      it "returns nil if it can't find a cycle after the max iterations" do
        cd = described_class.new {|x| x }
        expect(cd.cycle_finder(1000)).to be_nil
      end

      it "handles offsets" do
        cd = described_class.new do |x|
          if x < 123
            x
          else
            x % 7
          end
        end
        expect(cd.cycle_finder).to eq(7)
        expect(cd.cycle_length).to eq(7)
        expect(cd.cycle_first_index).to eq(123)
      end

      it "handles cycles smaller than min_cycle_length by returning repeats" do
        cd = described_class.new(min_cycle_length: 10) {|x| x % 5 }
        expect(cd.cycle_finder).to eq(10)
        expect(cd.cycle).to eq([0,1,2,3,4,0,1,2,3,4])
        expect(cd.results.length).to eq(30)
        expect(cd.cycle_first_index).to eq(0)
      end

      it "handles cycles larger than max_cycle_length by returning nil" do
        cd = described_class.new(max_cycle_length: 4) {|x| x % 5 }
        expect(cd.cycle_finder).to be_nil
      end

      it "handles small min_repeats" do
        cd = described_class.new(min_repeats: 2) {|x| x % 5 }
        expect(cd.cycle_finder).to eq(5)
        expect(cd.results.length).to eq(10)
        expect(cd.cycle_first_index).to eq(0)
      end

      it "handles large min_repeats" do
        cd = described_class.new(min_repeats: 5) {|x| x % 5 }
        expect(cd.cycle_finder).to eq(5)
        expect(cd.results.length).to eq(25)
        expect(cd.cycle_first_index).to eq(0)
      end
    end

    describe "#[]" do
      it "returns the value at the index" do
        cd.cycle_finder
        expect(cd[7]).to eq(2)
      end

      it "returns the value of indexes that haven't been calculated" do
        cd.cycle_finder
        expect(cd.results[16]).to be_nil
        expect(cd[16]).to eq(1)
      end

      it "handles offsets" do
        cd = described_class.new do |x|
          if x < 13
            x
          else
            (x - 13) % 7
          end
        end
        cd.cycle_finder

        expect(cd.results[36]).to be_nil
        expect(cd[36]).to eq(2)
      end
    end
  end
end
