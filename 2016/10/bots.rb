require 'set'
require '../lib/grid.rb'

module Advent

  class Bots
    attr_accessor :debug
    attr_reader :inputs, :outputs, :bots, :bot_receives

    def initialize(input)
      @debug = false
      @inputs = {}
      @bots = []
      @bot_receives = []
      @bot_inputs = []
      input.each_line do |line|
        line.chomp!
        if line =~ /^value (\d+) goes to bot (\d+)$/
          @inputs[$1.to_i] = $2.to_i
          @bot_receives[$2.to_i] ||= []
          @bot_receives[$2.to_i] << [:input, $1.to_i]
        elsif line =~ /^bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)$/
          giving_bot = $1.to_i
          low_out = $2.to_sym
          low_out_num = $3.to_i
          high_out = $4.to_sym
          high_out_num = $5.to_i

          @bots[giving_bot] = [low_out, low_out_num, high_out, high_out_num]
          if low_out == :bot
            @bot_receives[low_out_num] ||= []
            @bot_receives[low_out_num] << [:bot, giving_bot]
          end
          if high_out == :bot
            @bot_receives[high_out_num] ||= []
            @bot_receives[high_out_num] << [:bot, giving_bot]
          end
        end
      end
    end

    def debug!
      @debug = true
    end


    def find_common_bot(chip_a, chip_b)
      sorted_chips = [chip_a, chip_b].sort
      @bots.each_with_index do |val, bot|
        get_inputs(bot)
        found_bot = @bot_inputs.index sorted_chips
        return found_bot if found_bot
      end
      nil
    end

    def get_inputs(bot)
      return @bot_inputs[bot] if @bot_inputs[bot]
      acc = []
      @bot_receives[bot].each do |inps|
        typ, num = inps
        acc << num if typ == :input
        if typ == :bot
          low, high = get_inputs(num)
          low_out, low_out_num = @bots[num].first(2)
          if low_out == :bot && low_out_num == bot
            acc << low
          else
            acc << high
          end
        end
      end
      @bot_inputs[bot] = acc.sort
    end
  end
end
