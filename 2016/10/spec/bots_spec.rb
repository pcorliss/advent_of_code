require './bots.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
    EOS
  }

  describe Advent::Bots do
    let(:ad) { Advent::Bots.new(input) }

    describe "#new" do
      it "inits bot inputs" do
        expect(ad.inputs).to eq({
          5 => 2,
          3 => 1,
          2 => 2,
        })
      end

      it "inits bot outputs" do
        expect(ad.bots).to eq([
          [:output, 2, :output, 0],
          [:output, 1, :bot, 0],
          [:bot, 1, :bot, 0],
        ])
      end

      it "inits bot receives" do
        expect(ad.bot_receives[0]).to contain_exactly(
          [:bot, 2], [:bot, 1]
        )
      end
    end

    describe "#get_inputs" do
      it "returns the two values given to it when both are inputs and ordered by high and low" do
        expect(ad.get_inputs(2)).to eq([2,5])
      end

      it "returns the two values given to it when only one is an input" do
        expect(ad.get_inputs(1)).to eq([2,3])
      end

      it "returns the two values given to it when it's entirely composite" do
        expect(ad.get_inputs(0)).to eq([3,5])
      end
    end

    describe "#find_common_bot" do
      {
        [5,2] => 2,
        [3,2] => 1,
        [5,3] => 0,
        [nil, nil] => nil,
      }.each do |chips, bot|
        it "returns the common bot #{bot} that two given chips #{chips} traversed" do
          expect(ad.find_common_bot(*chips)).to eq(bot)
        end
      end
    end

    describe "#output_value" do
      [ 5, 2, 3 ].each_with_index do |val, output|
        it "returns the value #{val} received by a given output #{output}" do
          expect(ad.output_value(output)).to eq(val)
        end
      end
    end

    context "validation" do
    end
  end
end
