require './lens.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    EOS
  }

  describe Advent::Lens do
    let(:ad) { Advent::Lens.new(input) }

    describe "#new" do
      it "inits a list of strings/commands" do
        expect(ad.commands).to eq([
          'rn=1','cm-','qp=3','cm=2','qp-','pc=4','ot=9','ab=5','pc-','pc=6','ot=7'
        ])
      end
    end

    describe "#hashing" do
      it "Hashes a string into an integer" do
        expect(ad.hashing('HASH')).to eq(52)
      end
    end

    describe "#command_hash_sum" do
      it "returns the sum of hashing all the commands" do
        expect(ad.command_hash_sum).to eq(1320)
      end
    end

    context "validation" do
    end
  end
end
