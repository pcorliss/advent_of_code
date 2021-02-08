require 'set'
require '../lib/grid.rb'

module Advent

  class Signal
    attr_accessor :debug
    attr_reader :signals

    def initialize(input)
      @debug = false
      @signals = input.each_line.map(&:chomp)
    end

    def debug!
      @debug = true
    end

    def common_map
      common = []
      @signals.each do |signal|
        signal.each_char.each_with_index do |char, idx|
          common[idx] ||= {}
          common[idx][char] ||= 0
          common[idx][char] += 1
        end
      end
      common
    end

    def error_correct
      message = common_map.map do |frequency_map|
        frequency_map.keys.max_by do |char|
          frequency_map[char]
        end
      end

      message.join
    end

    def least_common
      message = common_map.map do |frequency_map|
        frequency_map.keys.min_by do |char|
          frequency_map[char]
        end
      end

      message.join
    end
  end
end
