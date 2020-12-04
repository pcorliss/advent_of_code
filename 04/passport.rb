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
    # byr (Birth Year)
    # iyr (Issue Year)
    # eyr (Expiration Year)
    # hgt (Height)
    # hcl (Hair Color)
    # ecl (Eye Color)
    # pid (Passport ID)
    # cid (Country ID)
    REQUIRED_FIELDS = %i(
      byr
      iyr
      eyr
      hgt
      hcl
      ecl
      pid
    )

    attr_reader :fields

    def initialize(input)
      @fields = input.split(/\s+/).inject(Hash.new) do |h, f|
        k, v = f.split(":")
        h[k.to_sym] = v
        h
      end
    end

    def valid?
      REQUIRED_FIELDS.all? do |field|
        @fields.has_key? field
      end
    end
  end
end
