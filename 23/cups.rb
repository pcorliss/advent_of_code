require 'set'

module Advent

  class Cups
    attr_reader :current_pos, :cups
    def initialize(input, moves = 100)
      @current_pos = 0
      @cups = input.chomp.split('').map(&:to_i)
      @max = @cups.max
      @min = @cups.min
      @move = 0
    end

    def move!
      moving_elements = []
      current_label = @cups[@current_pos]
      puts "#{@move + 1}: Pos: #{@current_pos} Label: #{current_label}"
      3.times do 
        pos = @current_pos + 1
        if pos >= @cups.length
          pos = 0
        end
        moving_elements << @cups.delete_at(pos)
      end
      puts "Moving: #{moving_elements} Cups: #{@cups}"
      new_position = nil
      decrementer = 1
      until new_position  do
        new_label = current_label - decrementer
        if new_label < @min
          new_label = @max
          decrementer = -1 * (@max - current_label)
        end
        new_position = @cups.index(new_label)
        decrementer += 1
        puts "New Label: #{new_label} New Position: #{new_position}"
        raise "too many cycles" if decrementer > 10
      end

      @cups.insert(new_position + 1, *moving_elements)

      # for easier testing we're going to rotate the array until the positions are consistent
      until current_label == @cups[@current_pos] do
        puts "Rotating: #{@cups}"
        @cups.rotate!
      end

      puts "Cups: #{@cups}"
      puts ""

      @current_pos = (@current_pos + 1) % @cups.length
      @move += 1
    end

    def cups_starting_from_1
      until @cups.first == 1 do
        puts "Rotating: #{@cups}"
        @cups.rotate!
      end
      @cups.slice(1..)
    end
  end
end
