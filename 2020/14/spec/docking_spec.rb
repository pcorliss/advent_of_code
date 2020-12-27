require '../docking.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      mem[8] = 11
      mem[7] = 101
      mem[8] = 0
    EOS
  }

  let(:input_prime) {
    <<~EOS
      mask = 000000000000000000000000000000X1001X
      mem[42] = 100
      mask = 00000000000000000000000000000000X0XX
      mem[26] = 1
    EOS
  }

  describe Advent::Docking do
    let(:ad) { Advent::Docking.new(input) }

    describe "#new" do
      it "sets the and_mask" do
        expect(ad.nand_mask).to eq("10".to_i(2))
      end

      it "sets the or_mask" do
        expect(ad.or_mask).to eq("1000000".to_i(2))
      end

      it "inits_memory" do
        expect(ad.memory).to be_a(Hash)
        expect(ad.memory[8]).to be_a(Integer)
      end

      it "applies_the_mask" do
        expect(ad.memory[7]).to eq(101)
        expect(ad.memory[8]).to eq(64)
      end

      context "part two" do
        let(:ad) { Advent::Docking.new(input_prime, true) }
        it "modifies multiple positions in memory" do
          expect(ad.memory_prime[58]).to eq(100)
          expect(ad.memory_prime[59]).to eq(100)
        end
      end
    end

    describe "#sum" do
      it "returns the sum of memory after masking" do
        expect(ad.sum).to eq(165)
      end
    end

    describe "#sum_prime" do
      let(:ad) { Advent::Docking.new(input_prime, true) }

      it "returns the sum of memory after masking" do
        expect(ad.sum_prime).to eq(208)
      end
    end

    describe "#set_memory_prime" do
      let(:input) {
        <<~EOS
        EOS
      }

      it "handles a base case where x_mask is empty" do
        ad.set_memory_prime(42, 7, [])
        expect(ad.memory_prime[42]).to eq(7)
      end

      it "handles a base case where x_mask has one bit set" do
        ad.set_memory_prime(7, 7, [1])
        expect(ad.memory_prime[7]).to eq(7)
        expect(ad.memory_prime[6]).to eq(7)
        ad.set_memory_prime(6, 8, [1])
        expect(ad.memory_prime[7]).to eq(8)
        expect(ad.memory_prime[6]).to eq(8)
      end

      it "handles a case where x_mask has two bits set" do
        # 111 110 100 101
        ad.set_memory_prime(7, 7, [1, 2])
        expect(ad.memory_prime[7]).to eq(7)
        expect(ad.memory_prime[6]).to eq(7)
        expect(ad.memory_prime[5]).to eq(7)
        expect(ad.memory_prime[4]).to eq(7)
      end

      it "handles a case where x_mask has three bits set" do
        # 111 110 100 101
        # 011 010 000 001
        ad.set_memory_prime(7, 7, [1, 2, 4])
        expect(ad.memory_prime[7]).to eq(7)
        expect(ad.memory_prime[6]).to eq(7)
        expect(ad.memory_prime[5]).to eq(7)
        expect(ad.memory_prime[4]).to eq(7)
        expect(ad.memory_prime[3]).to eq(7)
        expect(ad.memory_prime[2]).to eq(7)
        expect(ad.memory_prime[1]).to eq(7)
        expect(ad.memory_prime[0]).to eq(7)
      end
    end

    context "validation" do
      let(:ad) { Advent::Docking.new(input_prime, true) }
      {
        16 => 1,
        17 => 1,
        18 => 1,
        19 => 1,
        24 => 1,
        25 => 1,
        26 => 1,
        27 => 1,
        58 => 100,
        59 => 100,
      }.each do |mem, val|
        it "mem addr #{mem} to eq #{val}" do
          expect(ad.memory_prime[mem]).to eq(val)
        end
      end
    end
  end
end
