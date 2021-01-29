require './medicine.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
H => HO
H => OH
O => HH

HOH
    EOS
  }

  let(:lower_input) {
    <<~EOS
Ha => HbHO
Hb => OHaH
H => OHHc
O => HH

HaOHbH
    EOS
  }

  describe Advent::Medicine do
    let(:ad) { Advent::Medicine.new(input) }

    describe "#new" do
      it "inits a replace hash" do
        expect(ad.replace['H']).to contain_exactly(['H','O'], ['O','H'])
        expect(ad.replace['O']).to contain_exactly(['H','H'])
      end

      it "inits a starting molecule" do
        expect(ad.molecule).to eq(['H','O','H'])
      end

      it "recognizes lowercase chars properly" do
        ad = Advent::Medicine.new(lower_input)
        expect(ad.molecule).to eq(['Ha','O','Hb','H'])
        expect(ad.replace['H']).to contain_exactly(['O','H','Hc'])
        expect(ad.replace['Ha']).to contain_exactly(['Hb','H','O'])
        expect(ad.replace['Hb']).to contain_exactly(['O','Ha','H'])
      end
    end

    describe "replacements" do
      {
        ['H'] => [['H', 'O'], ['O', 'H']],
        ['O'] => [['H', 'H']],
        ['H','O','H'] => [['H','O','O','H'], ['H','O','H','O'], ['O','H','O', 'H'], ['H','H','H','H']],
      }.each do |starting_mol, expected|
        it "expected #{expected.count} molecules when receiving #{starting_mol}" do
          expect(ad.replacements(starting_mol)).to contain_exactly(*expected)
        end
      end

      it "returns the expected count from 'HOHOHO'" do
        expect(ad.replacements('HOHOHO'.split('')).count).to eq(7)
      end

      it "doesn't blow up if there's no replacement for a given atom" do
        expect(ad.replacements(['C'])).to be_empty
      end
    end

    context "validation" do
    end
  end
end
