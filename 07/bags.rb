require 'set'

module Advent

  class Bag
    attr_reader :rules
    def initialize(input)
      @rules = input.lines.map do |line|
        l = line.chomp
        BagReq.new(l)
      end
    end
  end

  class BagReq
    attr_reader :req
    ID_REGEX = /^(\w+ \w+) bags contain/
    CONTAIN_REGEX = /\d+ (\w+ \w+) bag[s]{0,1}/

    def initialize(input)
      parse!(input)
    end

    def parse!(input)
      @req = {}
      if input =~ ID_REGEX
        key = $1
        @req[key] = Set.new(input.scan(CONTAIN_REGEX).flatten)
      end
    end
  end
end
