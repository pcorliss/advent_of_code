require './asteroids.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Asteroids do
    let(:ad) { Advent::Asteroids.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end

  describe Advent::IntCode do
    let(:input) {
      <<~EOS
      1,9,10,3,2,3,11,0,99,30,40,50
      EOS
    }

    let(:ad) { Advent::IntCode.new(input) }

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

      context "parameter modes" do
        # ABCDE
        # DE - two digit opcode
        # C - Mode of 1st param
        # B - Mode of 2nd param
        # A - Mode of 3rd param - Parameters that an instruction writes to will never be in immediate mode.
        #
        # 1 == immediate mode
        # 00 == position mode

        {
              "1,5,6,7,99,8,9,0" => [   1,5,6,7,99,8,9,17],
             "01,5,6,7,99,8,9,0" => [   1,5,6,7,99,8,9,17],
            "001,5,6,7,99,8,9,0" => [   1,5,6,7,99,8,9,17],
           "0001,5,6,7,99,8,9,0" => [   1,5,6,7,99,8,9,17],
          "00001,5,6,7,99,8,9,0" => [   1,5,6,7,99,8,9,17],
          "00101,5,6,7,99,8,9,0" => [ 101,5,6,7,99,8,9,14],
          "01001,5,6,7,99,8,9,0" => [1001,5,6,7,99,8,9,14],
          "01101,5,6,7,99,8,9,0" => [1101,5,6,7,99,8,9,11],
              "2,5,6,7,99,8,9,0" => [   2,5,6,7,99,8,9,72],
             "02,5,6,7,99,8,9,0" => [   2,5,6,7,99,8,9,72],
            "002,5,6,7,99,8,9,0" => [   2,5,6,7,99,8,9,72],
           "0002,5,6,7,99,8,9,0" => [   2,5,6,7,99,8,9,72],
          "00002,5,6,7,99,8,9,0" => [   2,5,6,7,99,8,9,72],
          "00102,5,6,7,99,8,9,0" => [ 102,5,6,7,99,8,9,45],
          "01002,5,6,7,99,8,9,0" => [1002,5,6,7,99,8,9,48],
          "01102,5,6,7,99,8,9,0" => [1102,5,6,7,99,8,9,30],
        }.each do |input, expected|
          it "takes an input of #{input} and results in #{expected}" do
            ad = Advent::IntCode.new(input)
            ad.debug!
            ad.run!
            expect(ad.instructions).to eq(expected)
          end
        end
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
          ad = Advent::IntCode.new(input)
          ad.run!
          expect(ad.instructions).to eq(expected)
        end
      end
    end
  end
end
