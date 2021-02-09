require 'set'
require '../lib/grid.rb'

module Advent

  class Compress
    attr_accessor :debug
    attr_reader :string

    def initialize(input)
      @debug = false
      @string = input.gsub(/\s+/,'')
    end

    def debug!
      @debug = true
    end

    # reads chars until it encounters a break point and returns string and position
    def read_until(str, start_pos, break_char)
      new_str = ""
      i = start_pos
      while i < str.length do
        break if str[i] == break_char
        new_str << str[i]
        i += 1
      end

      [i, new_str]
    end

    def decode(str)
      new_str = ""
      i = 0
      while i < str.length do
        i, sub = read_until(str, i, '(')
        new_str += sub
        break unless i < str.length
        # puts "#{i} #{new_str} #{sub}" if @debug
        i, chars_to_read = read_until(str, i + 1, 'x')
        i, times_to_repeat = read_until(str, i + 1, ')')
        sub = str[(i+1)..(i+chars_to_read.to_i)]
        # puts "(#{chars_to_read}x#{times_to_repeat}) - #{sub}" if @debug
        new_str += sub * times_to_repeat.to_i
        i += chars_to_read.to_i + 1
      end
      new_str
    end

    def decodev2(str)
      prev_length = str.length
      new_length = 0
      new_str = str
      while new_length != prev_length do
        prev_length = new_str.length
        new_str = decode(new_str)
        new_length = new_str.length
        puts "New Length: #{new_length}" if @debug
      end
      new_str
    end

    def decode_length(str)
      counter = 0
      i = 0
      depth = Kernel.caller.select {|c| c.include? __method__.to_s}.count
      while i < str.length do
        i, sub = read_until(str, i, '(')
        counter += sub.length
        puts "#{"\t" * depth}Counter: #{counter} - Added #{sub.length} '#{sub}'" if @debug
        break unless i < str.length
        i, chars_to_read = read_until(str, i + 1, 'x')
        i, times_to_repeat = read_until(str, i + 1, ')')
        sub = str[(i+1)..(i+chars_to_read.to_i)]
        counter += times_to_repeat.to_i * decode_length(sub)
        i += chars_to_read.to_i + 1
      end
      counter
    end
  end
end
