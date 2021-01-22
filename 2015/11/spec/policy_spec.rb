require './policy.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    abcdefgh
    EOS
  }

  describe Advent::Policy do
    let(:ad) { Advent::Policy.new(input) }

    describe "#new" do
      it "inits the current password as the input" do
        expect(ad.password).to eq('abcdefgh')
      end
    end

    describe "#next_password" do
      it "increments the password" do
        expect(ad.next_password('aaa')).to eq('aab')
      end

      it "handles z's" do
        expect(ad.next_password('azzzz')).to eq('baaaa')
      end

      it "handles new lengths" do
        expect(ad.next_password('zzzz')).to eq('aaaaa')
      end
    end

    describe "#valid?" do
      it "returns true for valid passwords" do
        expect(ad.valid?('abcdffaa')).to be_truthy
        expect(ad.valid?('ghjaabcc')).to be_truthy
      end

      it "returns false if the password doesn't include an increasing straight 'efg' of letters" do
        expect(ad.valid?('abbceffg')).to be_falsey
      end

      it "returns false if the password contains 'i' 'o' or 'l'" do
        expect(ad.valid?('gijaabcc')).to be_falsey
        expect(ad.valid?('gojaabcc')).to be_falsey
        expect(ad.valid?('gljaabcc')).to be_falsey
      end

      it "returns false if the password doesn't contain two different pairs of letters that don't overlap" do
        expect(ad.valid?('abbcegjkabc')).to be_falsey
      end
    end

    context "validation" do
      {
        'abcdefgh' => 'abcdffaa',
        # 'ghijklmn' => 'ghjaabcc',
      }.each do |inp, expected|
        it "returns the next valid_password #{expected} for #{inp}" do
          # ad.debug!
          expect(ad.next_valid_password(inp)).to eq(expected)
        end
      end
    end
  end
end
