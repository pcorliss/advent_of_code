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

    def quick_restore(ref, data)
      data.each_with_index do |d, idx|
        ref[idx] = d
      end
    end

    def match?(rules, chars)
      # can add if empty check here for whole string check
      # sub_match? eats the chars so we can do this although it's bad
      chars = chars.chars if chars.is_a? String
      sub = sub_match?(rules, chars)
      empty = chars.empty?
      # puts "Sub: #{sub} Empty: #{empty} Chars: #{chars}"
      sub && empty
    end

    #recursive function, takes rules and chars, calls down the stack to check rule by rule
    def sub_match?(rules, chars)
      # puts "R-Checking: #{rules} against #{chars}"
      if rules.include? '|' # all inputs with conditionals seem to hanve only two elements
        return sub_match?(rules.slice(0..1), chars) || sub_match?(rules.slice(3..5), chars)
      end
      chars_orig = chars.clone
      rules.each do |r|
        rule = rule_parser[r]
        # puts "  Checking: #{r} #{rule} against #{chars}"
        if rule.length == 1 && rule.first.is_a?(String)
          char = chars.shift
          if rule != [char]
            quick_restore(chars, chars_orig)
            # puts "Char Check Failure!"
            return false 
          end
        else
          unless sub_match?(rule, chars)
            quick_restore(chars, chars_orig)
            # puts "Sub Match Failure!"
            return false 
          end
        end
      end
      # puts "Returning True! #{chars}"
      true
    end

    def match_count
      @inputs.count do |input|
        match?(rule_parser.first, input)
      end
    end
  end
end
