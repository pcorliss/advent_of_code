require 'set'
require 'benchmark'

module Advent

  class Rules
    attr_reader :inputs, :rules
    def initialize(input)
      @rules = []
      @inputs = []
      @reg = {}
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

    def parse_rule_to_regex(rule)
      return @reg[rule] if @reg[rule]
      #puts "Parsing: #{rule}"
      joined = rule.split(" ").map do |r|
        #puts "\tChecking on #{r.inspect}"
        if r.match(/\d+/)
          #puts "\tRecursing #{rule_parser[r.to_i]}"
          parse_rule_to_regex(rule_parser[r.to_i].join(" "))
        else
          r
        end
      end.join("")
      joined = "(#{joined})" if joined.include? "|"
      @reg[rule] = joined
    end

    def rules_regex
      return @rules_regex if @rules_regex
      @rules_regex = parse_rule_to_regex("0")
      @rules_regex
    end

    def gsub_rules!
      @rules.map! do |r|
        # elements = r.split(" ").map do |e|
        #   next if e == "|"
        #   next unless e.match(/\d+/)
        #   sub = @rules[e.to_i]
        #   if sub.length == 1
        #     sub.to_s
        #   elsif sub
        #   else
        #     "(#{sub})"
        #   end
        # end
      end
    end

    def simplify_rules!
      #puts "Rules: #{rule_parser}"
      rule_parser.map! do |r|
        # puts "\t#{r}"
        r.map do |re|
          if re.is_a? String
            re
          else
            # puts "\t\t#{re} -- #{rule_parser[re]}"
            lookup = rule_parser[re]
            lookup = lookup.first if lookup.length == 1
            lookup
          end
        end
      end
    end

    def match?(rules, chars)
      # reg = ''
      #
      # !!chars.match(/#{reg}/)
      # puts rule_parser.inspect
      # naive_match?(rules,chars)
      # !!rules_regex.match(chars)
      reg = parse_rule_to_regex(rules.join(" "))
      # puts "Expr: #{reg}"
      m = chars.match(/^#{reg}$/)
      # puts "Match: #{m.inspect}"
      !!m
    end

    def naive_match?(rules, chars)
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

    def mutating_rules_match_count
      @rule_parser[8] = [1000]
      @rule_parser[11] = [2000]
      10.times.map do |i|
        @reg = {}
        # 8: 42 | 42 8
        # 11: 42 31 | 42 11 31

        @rule_parser[1000 + i] = [42]
        @rule_parser[2000 + i] = [42,31]
        m = nil
        t = Benchmark.measure do
          m = @inputs.count do |input|
            match?(rule_parser.first, input)
          end
        end
        puts "Matched: #{m} in #{t}"
        @rule_parser[1000 + i] = [42, "|", 42, 1001 + i]
        @rule_parser[2000 + i] = [42, 31, "|", 42, 2001 + i, 31]
        m
      end
    end
  end
end
