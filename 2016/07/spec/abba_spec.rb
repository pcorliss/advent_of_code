require './abba.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    abba[mnop]qrst
    abcd[bddb]xyyx
    aaaa[qwer]tyui
    ioxxoj[asdfgh]zxcvbn
    EOS
  }

  describe Advent::Abba do
    let(:ad) { Advent::Abba.new(input) }

    describe "#new" do
      it "inits a list of ips" do
        expect(ad.ips.count).to eq(4)
        expect(ad.ips.first).to eq("abba[mnop]qrst")
      end
    end

    describe "#contains_abba?" do
      it "returns true if the string is an abba" do
        expect(ad.contains_abba?("abba")).to be_truthy
      end

      it "returns true if the abbs is part of a larger string" do
        expect(ad.contains_abba?("zabbay")).to be_truthy
      end

      it "returns false if the string doesn't contain an abba" do
        expect(ad.contains_abba?("qwer")).to be_falsey
      end

      it "returns false if the string contains the same four chars repeated" do
        expect(ad.contains_abba?("aaaa")).to be_falsey
      end
    end

    describe "#decompose_ip" do
      it "returns a hash with the hypernet and the strings" do
        expect(ad.decompose_ip("ioxxoj[asdfgh]zxcvbn")).to eq({
          segments: ["ioxxoj", "asdfgh", "zxcvbn"],
          nonhyper: ["ioxxoj", "zxcvbn"],
          hypernet: ["asdfgh"],
        })
      end
    end

    describe "supports_tls?" do
      {
        "abba[mnop]qrst" => true, # supports TLS (abba outside square brackets).
        "abcd[bddb]xyyx" => false, # does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
        "aaaa[qwer]tyui" => false, # does not support TLS (aaaa is invalid; the interior characters must be different).
        "ioxxoj[asdfgh]zxcvbn" => true, # supports TLS (oxxo is outside square brackets, even though it's within a larger string).
      }.each do |str, expected|
        it "returns #{expected} for #{str}" do
          expect(ad.supports_tls?(str)).to eq(expected)
        end
      end
    end

    context "validation" do
    end
  end
end
