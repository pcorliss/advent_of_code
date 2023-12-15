require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Lens
    attr_accessor :debug
    attr_reader :commands, :boxes

    def initialize(input)
      @debug = false
      @commands = input.chomp.split(',')
      @boxes = Array.new(256) { Array.new }
    end

    def debug!
      @debug = true
    end

    def hashing(str)
      str.each_char.inject(0) do |val, c|
        val += c.ord
        val *= 17
        val %= 256
      end
    end

    def command_hash_sum
      @commands.sum{ |c| hashing(c) }
    end

    def run_command(cmd)
      label, lens = cmd.split(/[\-\=]/)
      lens = lens.to_i
      box = @boxes[hashing(label)]
      if cmd.end_with?('-')
        box.delete_if { |l| l[0] == label }
      else
        existing_label_index = box.index { |l| l.first == label }
        if existing_label_index
          box[existing_label_index] = [label, lens]
        else
          box << [label, lens]
        end
      end
    end

    def run_all_commands
      @commands.each do |cmd|
        run_command(cmd)
      end
    end

    # rn: 1 (box 0) * 1 (first slot) * 1 (focal length) = 1
    # cm: 1 (box 0) * 2 (second slot) * 2 (focal length) = 4
    # ot: 4 (box 3) * 1 (first slot) * 7 (focal length) = 28
    # ab: 4 (box 3) * 2 (second slot) * 5 (focal length) = 40
    # pc: 4 (box 3) * 3 (third slot) * 6 (focal length) = 72
    def focusing_power
      @boxes.each_with_index.sum do |box, box_idx|
        box.each_with_index.sum do |(label, lens), lens_idx|
          (box_idx + 1) * (lens_idx + 1) * lens
        end
      end
    end
  end
end
