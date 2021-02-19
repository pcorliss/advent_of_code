require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Scramble
    attr_accessor :debug
    attr_reader :rules

    def initialize(input)
      @debug = false
      @rules = input.each_line.map do |line|
        line.chomp!
        action, mod, *x = line.split(' ')
        action = (action + '_' + mod).to_sym
        case action
        when :swap_position
          [action, x[0].to_i, x[3].to_i]
        when :swap_letter
          [action, x[0], x[3]]
        when :reverse_positions
          [action, x[0].to_i, x[2].to_i]
        when :rotate_left, :rotate_right
          [action, x[0].to_i]
        when :move_position
          [action, x[0].to_i, x[3].to_i]
        when :rotate_based
          [action, x[4]]
        else
          [action]
        end
      end
    end

    def debug!
      @debug = true
    end

    def swap_position(chars, a, b)
      tmp = chars[a]
      chars[a] = chars[b]
      chars[b] = tmp
      chars
    end

    def swap_letter(chars, a, b)
      chars.map! do |char|
        if char == a
          b
        elsif char == b
          a
        else
          char
        end
      end
      chars
    end

    def reverse_positions(chars, a, b)
      i = a
      j = b
      k = (b - a) / 2 + a
      while i <= k do
        tmp = chars[i]
        chars[i] = chars[j]
        chars[j] = tmp
        i += 1
        j -= 1
      end
      chars
    end

    def rotate_left(chars, a)
      chars.rotate!(a)
    end

    def rotate_right(chars, a)
      chars.rotate!(-1 * a)
      chars
    end

    def move_position_forward(chars, a, b)
      i = a
      tmp = chars[i]
      while i < b do
        chars[i] = chars[i+1]
        i += 1
      end
      chars[b] = tmp
      chars
    end

    def move_position_backward(chars, a, b)
      i = a
      tmp = chars[i]
      while i > b do
        chars[i] = chars[i-1]
        i -= 1
      end
      chars[b] = tmp
      chars
    end

    def move_position(chars, a, b)
      if a < b
        move_position_forward(chars, a, b)
      else
        move_position_backward(chars, a, b)
      end
    end

    def rotate_based(chars, a)
      idx = chars.index(a)
      idx += 1 if idx >= 4
      rotate_right(chars, idx + 1)
    end

    def scramble(pw)
      pw = pw.chars.to_a
      @rules.each do |rule|
        meth, *args = rule
        pw_orig = pw.clone
        pw = self.__send__(meth, pw, *args)
        puts "#{meth.inspect} #{args} - #{pw_orig.join} -> #{pw.join}" if @debug
      end
      pw.join
    end
  end
end
