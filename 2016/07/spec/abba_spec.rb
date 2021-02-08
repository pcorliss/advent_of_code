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

    describe "#abba?" do
      it "returns true if the string is an abba" do
        expect(ad.abba?("abba")).to be_truthy
      end

      it "returns true if the abbs is part of a larger string" do
        expect(ad.abba?("zabbay")).to be_truthy
      end

      it "returns false if the string doesn't contain an abba" do
        expect(ad.abba?("qwer")).to be_falsey
      end

      it "returns false if the string contains the same four chars repeated" do
        expect(ad.abba?("aaaa")).to be_falsey
      end

      it "returns false if the string contains a non matching central pair" do
        expect(ad.abba?("abca")).to be_falsey
      end
    end

    describe "#aba" do
      it "returns true if the string is an aba" do
        expect(ad.aba("aba")).to eq([['a', 'b']])
      end

      it "returns true if the abbs is part of a larger string" do
        expect(ad.aba("zabay")).to eq([['a','b']])
      end

      it "returns false if the string doesn't contain an aba" do
        expect(ad.aba("qwer")).to be_empty
      end

      it "returns false if the string contains the same four chars repeated" do
        expect(ad.aba("aaaa")).to be_empty
      end

      it "returns all repeated sequences" do
        expect(ad.aba("zazbz")).to eq([['z','a'], ['z','b']])
      end
    end

    describe "#bab?" do
      it "returns true if the string is an bab" do
        expect(ad.bab?("bab", [['a','b']])).to be_truthy
      end

      it "returns true if the abbs is part of a larger string" do
        expect(ad.bab?("zbaby", [['a', 'b']])).to be_truthy
      end

      it "returns false if the string doesn't contain an bab" do
        expect(ad.bab?("qwer", [['a', 'b']])).to be_falsey
      end

      it "returns false if the string contains the same four chars repeated" do
        expect(ad.bab?("aaaa", [['a', 'b']])).to be_falsey
      end

      it "returns false if the string contains the wrong chars" do
        expect(ad.bab?("aba", [['a', 'b']])).to be_falsey
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

    describe "#supports_ssl?" do
      {
        "aba[bab]xyz" => true, # supports SSL (aba outside square brackets with corresponding bab within square brackets).
        "xyx[xyx]xyx" => false, # does not support SSL (xyx, but no corresponding yxy).
        "aaa[kek]eke" => true, # supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
        "zazbz[bzb]cdb" => true, # supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).
      }.each do |str, expected|
        it "returns #{expected} for #{str}" do
          # ad.debug!
          expect(ad.supports_ssl?(str)).to eq(expected)
        end
      end
    end

    context "validation" do
    end
  end
end
