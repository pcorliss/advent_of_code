require 'set'

module Advent
  class Ticket
    attr_reader :ticket, :tickets, :rules, :fields

    def initialize(input)
      @ticket = []
      @tickets = []
      @rules = []
      @fields = {}

      your = false
      nearby = false

      input.each_line do |line|
        l = line.chomp
        case l
        when ""
        when "your ticket:"
          your = true
        when "nearby tickets:"
          nearby = true
        else
          if nearby
            @tickets << l.split(",").map(&:to_i)
          elsif your
            @ticket = l.split(",").map(&:to_i)
          else
            field, rs = l.split(": ")
            rs = rs.split(" or ")
            rs.map! do |range|
              start, finish = range.split("-")
              (start.to_i..finish.to_i)
            end
            @rules.concat rs
            @fields[field] = rs
          end
        end
      end
    end

    def invalid_nums(nums)
      nums.select do |n|
        !@rules.any? { |f| f.include? n }
      end
    end

    def sum
      tickets.map do |t|
        invalid_nums(t)
      end.flatten.inject(:+)
    end

    def valid_tickets
      @tickets.select do |t|
        invalid_nums(t).empty?
      end
    end

    def field_mappings
      valid = valid_tickets
      # puts "Valid: #{valid}"
      mappings = []
      possible_mappings = {}
      valid.first.length.times do |idx|
        # puts "\tIdx: #{idx}"
        nums = valid.map { |v| v[idx] }
        # puts "\tNums: #{nums}"

        # Rework this to determine possible fields for each index
        # Then select the ones that only have 1 possible, then 2 possible, etc...
        @fields.each do |f, rs|
          # puts "\t\tField: #{f}"
          match = nums.all? do |n|
            rs.any? do |r|
              r.include? n
            end
          end
          # puts "\t\tMatch: #{match}"

          if match
            possible_mappings[f] ||= []
            possible_mappings[f] << idx
          end
        end
      end
      # puts "Possible: #{possible_mappings}"
      possible_mappings.sort_by { |f, v| v.length }.each do |f, v|
        idx = v.find do |val|
          mappings[val].nil?
        end
        mappings[idx] = f
      end
      mappings
    end

    def departure_info
      departure_fields = []
      field_mappings.each_with_index do |f, idx|
        if f.start_with? "departure"
          departure_fields << @ticket[idx]
        end
      end
      departure_fields
    end
  end
end
