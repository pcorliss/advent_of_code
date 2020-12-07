require 'set'

module Advent

  class Bag
    ID_REGEX = /^(\w+ \w+) bags contain/
    CONTAIN_REGEX = /\d+ (\w+ \w+) bag[s]{0,1}/

    attr_reader :rules

    def initialize(input)
      input.lines.map do |line|
        l = line.chomp
        add!(l)
      end
    end

    def add!(input)
      @rules ||= {}
      if input =~ ID_REGEX
        key = $1
        @rules[key] = Set.new(input.scan(CONTAIN_REGEX).flatten)
      end
    end

    def holding_bags(bag)
      @inverse_rules ||= {}
      return @inverse_rules[bag] if @inverse_rules[bag]
      @inverse_rules[bag] = Set.new
      @rules.each do |b, contents|
        if contents.include? bag
          @inverse_rules[bag].add b
          @inverse_rules[bag] |= holding_bags(b)
        end
      end

      @inverse_rules[bag]
    end
  end
end
