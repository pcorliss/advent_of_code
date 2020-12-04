require '../passport.rb'
require 'rspec'
require 'pry'

describe Advent do
  let(:input) {
    <<~EOS
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
    EOS
  }

  describe Advent::Four do
    let(:ad) { Advent::Four.new(input) }

    describe "#new" do
      it "takes an input and builds a collection of passports" do
        expect(ad.passports.count).to eq(4)
      end
    end

    context "validation" do
      it "reports 2 valid passports" do
        expect(ad.passports.count {|p| p.valid? }).to eq(2)
      end
    end
  end

  describe Advent::Passport do
    subject { Advent::Passport }
    let(:input) { "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm" }
    let(:passport) { subject.new(input) }
    let(:fields) {{
      ecl: "gry",
      pid: "860033327",
      eyr: "2020",
      hcl: "#fffffd",
      byr: "1937",
      iyr: "2017",
      cid: "147",
      hgt: "183cm",
    }}

    describe "#new" do
      it "takes a string as input and sets the fields" do
        expect(passport.fields).to eq(fields)
      end

      it "handles multiline string" do
        passport = subject.new(input.gsub(/\s/, "\n"))
        expect(passport.fields).to eq(fields)
      end
    end

    describe "#valid?" do
      %i(
        byr
        iyr
        eyr
        hgt
        hcl
        ecl
        pid
      ).each do |field|
        it "requires the #{field} field" do
          passport.fields.delete(field)
          expect(passport.valid?).to be_falsey
        end
      end

      %i(
        cid
      ).each do |field|
        it "does not require the #{field} field" do
          passport.fields.delete(field)
          expect(passport.valid?).to be_truthy
        end
      end

      it "is valid if it contains all fields" do
        expect(passport.valid?).to be_truthy
      end
    end
  end
end
