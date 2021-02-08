require './md5door.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    abc
    EOS
  }

  describe Advent::Md5door do
    let(:ad) { Advent::Md5door.new(input) }

    describe "#new" do
      it "inits a door id" do
        expect(ad.door).to eq('abc')
      end
    end

    describe "#gen_hash" do
      it "it takes an index and returns the first hash that starts with 5 zeroes" do
        expect(ad.gen_hash(3231920, 'abc')).to eq([3231929, "00000155f8105dff7f56ee10fa9b9abd"])
      end
    end

    context "validation" do
      # Takes 20s
      # it "constructs a password" do
      #   expect(ad.gen_pw).to eq('18f47a30')
      # end

      # it "constructs a password" do
      #   ad.debug!
      #   expect(ad.gen_pw_with_pos).to eq('05ace8e3')
      # end
    end
  end
end
