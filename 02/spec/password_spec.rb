require '../password.rb'
require 'rspec'

describe Advent::Two do
  let(:input) {
    <<~EOS
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    EOS
  }
  let(:ad) { Advent::Two.new(input) }

  describe "#new" do
    it "instantiates a set for each line" do
      expect(ad.input.count).to eq(3)
      expect(ad.input.class).to eq(Set)
    end

    it "each input entry contains a range" do
      expect(ad.input.first[0]).to eq((1..3))
    end

    it "each input entry contains a char" do
      expect(ad.input.first[1]).to eq("a")
    end
    it "each input entry contains a password" do
      expect(ad.input.first[2]).to eq("abcde")
    end
  end

  describe "#valid_password?" do
    it "returns false if the password doesn't have enough of a char" do
      expect(ad.valid_password?((1..3), "a", "bbb")).to be_falsey
    end

    it "returns false if the password too much of a char" do
      expect(ad.valid_password?((1..3), "a", "aaaa")).to be_falsey
    end

    it "returns true if the password matches the constraints" do
      expect(ad.valid_password?((1..3), "a", "aaa")).to be_truthy
    end
  end

  describe "#valid_password_count" do
    it "returns a count of valid passwords" do
      expect(ad.valid_password_count).to eq(2)
    end
  end
end

describe Advent::TwoPartTwo do
  let(:input) {
    <<~EOS
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    EOS
  }
  let(:ad) { Advent::TwoPartTwo.new(input) }

  describe "#new" do
    it "instantiates a set for each line" do
      expect(ad.input.count).to eq(3)
      expect(ad.input.class).to eq(Set)
    end

    it "each input entry contains a valid char index" do
      expect(ad.input.first[0]).to eq(1)
    end

    it "each input entry contains an invalid char index" do
      expect(ad.input.first[1]).to eq(3)
    end

    it "each input entry contains a char" do
      expect(ad.input.first[2]).to eq("a")
    end
    it "each input entry contains a password" do
      expect(ad.input.first[3]).to eq("abcde")
    end
  end

  describe "#valid_password?" do
    it "returns false if the password doesn't contain the char at the first point" do
      expect(ad.valid_password?(1, 3, "a", "bbb")).to be_falsey
    end

    it "returns false if the password doesn't contain the char at the second point" do
      expect(ad.valid_password?(1, 3, "a", "bbb")).to be_falsey
    end

    it "returns false if the password does contain the char at both points" do
      expect(ad.valid_password?(1, 3, "a", "aba")).to be_falsey
    end

    it "returns true if the password contains the char at the first point but not the second" do
      expect(ad.valid_password?(1, 3, "a", "aab")).to be_truthy
    end

    it "returns true if the password contains the char at the second point but not the first" do
      expect(ad.valid_password?(1, 3, "a", "baa")).to be_truthy
    end
  end

  describe "#valid_password_count" do
    it "returns a count of valid passwords" do
      expect(ad.valid_password_count).to eq(1)
    end
  end
end

