require './circuit.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
    EOS
  }

  describe Advent::Circuit do
    let(:ad) { Advent::Circuit.new(input) }

    describe "#new" do
      it "inits a set of instructions" do
        expect(ad.instructions.count).to eq(8)
        expect(ad.instructions['x']).to eq([123])
        expect(ad.instructions['f']).to eq([
          :lshift,
          'x',
          2
        ])
        expect(ad.instructions['h']).to eq([
          :not,
          'x',
        ])
      end
    end

    describe "#resolve" do
      let(:input) {
        <<~EOS
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    NOT 65412 -> aaa
    2 AND 7 -> bbb
    2 OR 5 -> ccc
    7 LSHIFT 1 -> ddd
    7 RSHIFT 1 -> eee
        EOS
      }

      it "resolves simple numerical instructions" do
        expect(ad.resolve('x')).to eq(123)
      end

      it "handles NOTs" do
        expect(ad.resolve('aaa')).to eq(123)
      end

      it "handles AND" do
        expect(ad.resolve('bbb')).to eq(2)
      end

      it "handles OR" do
        expect(ad.resolve('ccc')).to eq(7)
      end

      it "handles LSHIFT" do
        expect(ad.resolve('ddd')).to eq(14)
      end

      it "handles RSHIFT" do
        expect(ad.resolve('eee')).to eq(3)
      end

      it "handles nested instructions" do
        expect(ad.resolve('h')).to eq(65412)
      end
    end

    context "validation" do
      {
        'd' => 72,
        'e' => 507,
        'f' => 492,
        'g' => 114,
        'h' => 65412,
        'i' => 65079,
        'x' => 123,
        'y' => 456,
      }.each do |arg, expected|
        it "it returns #{expected} for #{arg}" do
          expect(ad.resolve(arg)).to eq(expected)
        end
      end
    end
  end
end
