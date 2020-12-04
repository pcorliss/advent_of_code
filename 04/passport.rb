require 'set'

module Advent

  class Four
    attr_reader :passports

    def initialize(input)
      @passports = input.split("\n\n").map do |passport_input|
        Passport.new(passport_input)
      end
    end
  end

  class Passport
    # byr (Birth Year) - four digits; at least 1920 and at most 2002.
    # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    # hgt (Height) - a number followed by either cm or in:
      # If cm, the number must be at least 150 and at most 193.
      # If in, the number must be at least 59 and at most 76.
    # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    # pid (Passport ID) - a nine-digit number, including leading zeroes.
    # cid (Country ID) - ignored, missing or not. 
    REQUIRED_FIELDS = %i(
      byr
      iyr
      eyr
      hgt
      hcl
      ecl
      pid
    )

    YEAR_RESTRICTIONS = {
      byr: [1920, 2002, 4],
      iyr: [2010, 2020, 4],
      eyr: [2020, 2030, 4],
    }

    attr_reader :fields

    def initialize(input)
      @fields = input.split(/\s+/).inject(Hash.new) do |h, f|
        k, v = f.split(":")
        h[k.to_sym] = v
        h
      end
    end

    def valid_year?(field, min, max, digits)
      return false unless field =~ /^\d{#{digits}}$/
      field_i = field.to_i
      return false if field_i > max || field_i < min
      true
    end

    def valid_height?
      height = @fields[:hgt]
      return false unless height =~ /^(\d+)(cm|in)$/
      num = $1
      metric = $2
      return true if metric == "cm" && num.to_i >= 150 && num.to_i <= 193
      return true if metric == "in" && num.to_i >= 59 && num.to_i <= 76
      false
    end

    def valid_hair?
      @fields[:hcl] =~ /^\#[0-9a-f]{6}$/
    end

    def valid?
      return false unless REQUIRED_FIELDS.all? do |field|
        @fields.has_key? field
      end

      return false unless YEAR_RESTRICTIONS.all? do |field, restrictions|
        valid_year?(@fields[field], *restrictions)
      end

      return false unless valid_height?

      return false unless valid_hair?

      true
    end
  end
end
