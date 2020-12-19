require 'set'

module Advent

  class Rules
    attr_reader :inputs, :rules
    def initialize(input)
      @rules = []
      @inputs = []
      input.each_line do |l|
        l = l.chomp
        if l =~ /^\d/
          @rules << l
        elsif !l.empty?
          @inputs << l
        end
      end
    end

    def rule_parser
      return @rule_parser if @rule_parser
      @rule_parser = []
      @rules.each do |r|
        idx, rule = r.split(": ")
        rule.gsub!('"', '')
        subrules = rule.split(" ").map do |subrule|
          if subrule =~ /\d+/
            subrule.to_i
          else
            subrule
          end
        end
        @rule_parser[idx.to_i] = subrules
      end
      @rule_parser
    end

    #recursive function, takes rules and chars, calls down the stack to check rule by rule
    def match?(rules, chars)
      rules.each do |r|
        puts "Checking: #{r} #{rule_parser[r]} against #{chars}"
        return false unless rule_parser[r] == [chars]
        # case r
        # when r.is_a? Integer
        #   rule_parser[r]
        # end
      end
      true
    end
  end
end
