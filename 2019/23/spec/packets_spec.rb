require './packets.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Packets do
    let(:ad) { Advent::Packets.new(input) }

    describe "#new" do
      it "instantiates 50 computers, each with it's own addr (0-49)" do
        expect(ad.computers.count).to eq(50)
        expect(ad.computers[49]).to be_a(Advent::IntCode)
        expect(ad.computers[49].inputs).to eq([49])
      end
    end

    context "validation" do
      it "retrieves a value form run" do
        ad.run_until_255
      end
    end
  end
end
