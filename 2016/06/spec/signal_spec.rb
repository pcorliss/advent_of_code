require './signal.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
    EOS
  }

  describe Advent::Signal do
    let(:ad) { Advent::Signal.new(input) }

    describe "#new" do
      it "inits a list of signals" do
        expect(ad.signals.count).to eq(16)
        expect(ad.signals.first).to eq('eedadn')
      end
    end

    describe "#error_correct" do
      it "returns the error corrected message" do
        expect(ad.error_correct).to eq("easter")
      end
    end

    describe "#least_common" do
      it "returns the error corrected message" do
        expect(ad.least_common).to eq("advent")
      end
    end

    context "validation" do
    end
  end
end
