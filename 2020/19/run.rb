#!/usr/bin/env ruby

require_relative 'rules'

input = File.read('./input.txt')

RubyVM::InstructionSequence.compile_option = {
    tailcall_optimization: true,
      trace_instruction: false
}

ad = Advent::Rules.new(input)
puts "Count: #{ad.match_count}"
puts "Mutating Count: #{ad.mutating_rules_match_count}"
