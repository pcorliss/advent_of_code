require 'set'

module Advent

  class Bag
    ID_REGEX = /^(\w+ \w+) bags contain/
    CONTAIN_REGEX = /(\d+) (\w+ \w+) bag[s]{0,1}/

    attr_reader :rules, :counts

    def initialize(input)
      input.lines.map do |line|
        l = line.chomp
        add!(l)
      end
    end

    def add!(input)
      @rules ||= {}
      @counts ||= {}
      if input =~ ID_REGEX
        key = $1
        bag_names = input.scan(CONTAIN_REGEX).map(&:last)
        @rules[key] = Set.new(bag_names)
        @counts[key] = input.scan(CONTAIN_REGEX)
      end
    end

    def required_bags(bag)
      @cached_bags ||= {}
      return @cached_bags[bag] if @cached_bags[bag]
      count = 0
      @counts[bag].each do |cnt, b|
        count += cnt.to_i
        count += cnt.to_i * required_bags(b)
      end

      @cached_bags[bag] = count
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
