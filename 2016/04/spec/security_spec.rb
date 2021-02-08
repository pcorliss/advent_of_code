require './security.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]
    EOS
  }

  describe Advent::Security do
    let(:ad) { Advent::Security.new(input) }

    describe "#new" do
      it "inits a list of rooms" do
        expect(ad.rooms.count).to eq(4)
        expect(ad.rooms.first).to eq("aaaaa-bbb-z-y-x-123[abxyz]")
      end
    end

    describe "#real?" do
      {
        "aaaaa-bbb-z-y-x-123[abxyz]" => true,
        "a-b-c-d-e-f-g-h-987[abcde]" => true,
        "not-a-real-room-404[oarel]" => true,
        "totally-real-room-200[decoy]" => false,
      }.each do |room, real|
        it "recognizes #{real ? "real" : "unreal"} rooms for #{room}" do
          # ad.debug!
          expect(ad.real?(room)).to eq(real)
        end
      end
    end

    context "validation" do
    end
  end
end
