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

      context "birth year validation" do
        it "at least 1920" do
          passport.fields[:byr] = "1919"
          expect(passport.valid?).to be_falsey
          passport.fields[:byr] = "1920"
          expect(passport.valid?).to be_truthy
        end

        it "no more than 2002" do
          passport.fields[:byr] = "2003"
          expect(passport.valid?).to be_falsey
          passport.fields[:byr] = "2002"
          expect(passport.valid?).to be_truthy
        end

        it "requires four digits" do
          passport.fields[:byr] = "2002a"
          expect(passport.valid?).to be_falsey
        end
      end

      context "issue year validation" do
        it "at least 2010" do
          passport.fields[:iyr] = "2009"
          expect(passport.valid?).to be_falsey
          passport.fields[:iyr] = "2010"
          expect(passport.valid?).to be_truthy
        end

        it "no more than 2020" do
          passport.fields[:iyr] = "2021"
          expect(passport.valid?).to be_falsey
          passport.fields[:iyr] = "2020"
          expect(passport.valid?).to be_truthy
        end

        it "requires four digits" do
          passport.fields[:iyr] = "2012a"
          expect(passport.valid?).to be_falsey
        end
      end

      context "expiration year validation" do
        it "at least 2020" do
          passport.fields[:eyr] = "2019"
          expect(passport.valid?).to be_falsey
          passport.fields[:eyr] = "2020"
          expect(passport.valid?).to be_truthy
        end

        it "no more than 2030" do
          passport.fields[:eyr] = "2031"
          expect(passport.valid?).to be_falsey
          passport.fields[:eyr] = "2030"
          expect(passport.valid?).to be_truthy
        end

        it "requires four digits" do
          passport.fields[:eyr] = "2030a"
          expect(passport.valid?).to be_falsey
        end
      end

      context "color validation" do
        context "hair" do
          it "requires a hex value" do
            passport.fields[:hcl] = "#00000"
            expect(passport.valid?).to be_falsey
            passport.fields[:hcl] = "#0000000"
            expect(passport.valid?).to be_falsey
            passport.fields[:hcl] = "#aaaaag"
            expect(passport.valid?).to be_falsey
            passport.fields[:hcl] = "0000000"
            expect(passport.valid?).to be_falsey
            passport.fields[:hcl] = "#000000"
            expect(passport.valid?).to be_truthy
            passport.fields[:hcl] = "#aaaaaa"
            expect(passport.valid?).to be_truthy
          end
        end

        context "eye" do

        end
      end

      context "height validation" do
        it "requires number followed by cm or in" do
          passport.fields[:hgt] = "150aa"
          expect(passport.valid?).to be_falsey
          passport.fields[:hgt] = "150"
          expect(passport.valid?).to be_falsey
          passport.fields[:hgt] = "150cm"
          expect(passport.valid?).to be_truthy
          passport.fields[:hgt] = "60in"
          expect(passport.valid?).to be_truthy
        end

        it "requires 150cm to 193cm" do
          passport.fields[:hgt] = "149cm"
          expect(passport.valid?).to be_falsey
          passport.fields[:hgt] = "194cm"
          expect(passport.valid?).to be_falsey
          passport.fields[:hgt] = "150cm"
          expect(passport.valid?).to be_truthy
          passport.fields[:hgt] = "193cm"
          expect(passport.valid?).to be_truthy
        end

        it "requires 59 to 76in" do
          passport.fields[:hgt] = "58in"
          expect(passport.valid?).to be_falsey
          passport.fields[:hgt] = "77in"
          expect(passport.valid?).to be_falsey
          passport.fields[:hgt] = "59in"
          expect(passport.valid?).to be_truthy
          passport.fields[:hgt] = "76in"
          expect(passport.valid?).to be_truthy
        end
      end
    end
  end
end
