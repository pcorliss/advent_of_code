require './alarm.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    1,9,10,3,2,3,11,0,99,30,40,50
    EOS
  }

  describe Advent::Alarm do
    let(:ad) { Advent::Alarm.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions).to eq([1,9,10,3,2,3,11,0,99,30,40,50])
      end
    end

    describe "#run!" do
      before do
        ad.run!
      end

      it "executes an addition instruction" do
        expect(ad.instructions[3]).to eq(70)
      end

      it "executes a multiplication instruction" do
        expect(ad.instructions[0]).to eq(3500)
      end
    end

    context "validation" do
      {
        "1,0,0,0,99" => [2,0,0,0,99],
        "2,3,0,3,99" => [2,3,0,6,99],
        "2,4,4,5,99,0" => [2,4,4,5,99,9801],
        "1,1,1,4,99,5,6,0,99" => [30,1,1,4,2,5,6,0,99],
      }.each do |input, expected|
        it "takes an input of #{input} and results in #{expected}" do
          ad = Advent::Alarm.new(input)
          ad.run!
          expect(ad.instructions).to eq(expected)
        end
      end
     end
  end
end
