require 'set'
require '../lib/grid.rb'

module Advent

  class AuntSue
    attr_accessor :debug
    attr_reader :aunts

    def initialize(input)
      @debug = false
      @aunts = []
      input.each_line do |line|
        line.chomp!
        # Sue 1: goldfish: 9, cars: 0, samoyeds: 9
        if line =~ /^Sue (\d+): (.*)$/
          idx = $1.to_i - 1
          properties = $2.split(', ')
          property_map = Hash[properties.map { |prop| k, v = prop.split(': '); [k.to_sym, v.to_i] }]
          @aunts[idx] = property_map
        end
      end
    end

    def filter(property_filter)
      aunt_set = {}
      @aunts.each_with_index do |properties, idx|
        property_filter.each do |prop_k, prop_v|
          aunt_set[prop_k] ||= Set.new
          aunt_set[prop_k].add(idx + 1) if !properties[prop_k]
          aunt_set[prop_k].add(idx + 1) if properties[prop_k] == prop_v
          puts "#{properties}-#{prop_k}-#{prop_v}-#{idx}" if @debug
        end
      end
      aunt_set.values.inject(:&)
    end

    def range_filter(property_filter)
      aunt_set = {}
      @aunts.each_with_index do |properties, idx|
        property_filter.each do |prop_k, prop_v|
          aunt_set[prop_k] ||= Set.new
          if properties[prop_k]
            case prop_k
            when :cats, :trees
              aunt_set[prop_k].add(idx + 1) if properties[prop_k] > prop_v
            when :pomeranians, :goldfish
              aunt_set[prop_k].add(idx + 1) if properties[prop_k] < prop_v
            else
              aunt_set[prop_k].add(idx + 1) if properties[prop_k] == prop_v
            end
          end
          aunt_set[prop_k].add(idx + 1) if !properties[prop_k]
          puts "#{properties}-#{prop_k}-#{prop_v}-#{idx}" if @debug
        end
      end
      aunt_set.values.inject(:&)
    end

    def debug!
      @debug = true
    end
  end
end
