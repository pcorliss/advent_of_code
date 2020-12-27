require 'set'

module Advent


  class Cups
    attr_reader :current_pos, :cups, :cups_prime
    def initialize(input, fill = 9, debug = true)
      @debug = debug
      @current_pos = 0
      @cups = input.chomp.split('').map(&:to_i)
      @max = @cups.max
      @min = @cups.min
      if fill > @max
        @cups.concat ((@max + 1)..fill).to_a
      end
      @move = 0
      @cups_prime = LinkedNumList.new(@cups, fill)
    end

    def move!
      moving_elements = []
      current_label = @cups[@current_pos]
      puts "#{@move + 1}: Pos: #{@current_pos} Label: #{current_label}" if @debug

      # 46% of CPU time
      moving_elements = @cups.slice!((@current_pos + 1)..(@current_pos + 3))
      if moving_elements.length < 3
        puts "Moving More Elements: #{moving_elements} 0..#{(2 - moving_elements.length)}" if @debug
        moving_elements.concat @cups.slice!(0..(2 - moving_elements.length))
      end
      puts "Moving: #{moving_elements} Cups: #{@cups}" if @debug
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
        puts "New Label: #{new_label} New Position: #{new_position}" if @debug
        raise "too many cycles" if decrementer > 10
      end

      # 48% of cpu time
      @cups.insert(new_position + 1, *moving_elements)

      if current_label != @cups[@current_pos]
        @current_pos = @cups.index(current_label)
      end

      puts "Cups: #{@cups}" if @debug
      puts "" if @debug

      @current_pos = (@current_pos + 1) % @cups.length
      @move += 1
    end

    def cups_starting_from_1
      until @cups.first == 1 do
        puts "Rotating: #{@cups}" if @debug
        @cups.rotate!
      end
      @cups.slice(1..)
    end
  end

  class LinkedNumList
    attr_reader :pos, :nums
    attr_accessor :debug

    def initialize(starting_nums, fill_to, debug = false)
      @nums = []
      @pos = nil
      @max = starting_nums.max
      @max = fill_to if fill_to > starting_nums.max
      @min = starting_nums.min
      @debug = debug
      prev = nil
      starting_nums.each do |n|
        @nums[n] = Node.new(n)
        @pos = @nums[n] if @pos.nil?
        prev.next = @nums[n] if prev
        prev = @nums[n]
      end
      ((starting_nums.max+1)..fill_to).each do |n|
        @nums[n] = Node.new(n)
        prev.next = @nums[n]
        prev = @nums[n]
      end

      prev.next = @pos
    end

    def to_a(starting = nil)
      walk = @pos
      walk = @nums[starting] if starting
      arr = []
      while arr.length < @nums.length - 1 do
        arr << walk.num
        walk = walk.next
      end
      arr
    end

    def advance!
      @pos = @pos.next
    end

    def move!
      puts "Start: #{to_a}" if @debug
      # slice out 3 elements
      a = @pos.next
      b = a.next
      c = b.next
      @pos.next = c.next
      puts "Spliced: #{to_a} #{a.num},#{b.num},#{c.num}" if @debug

      new_label = @pos.num - 1
      puts "Expected Label: #{new_label}" if @debug
      new_label = @max if new_label < 1
      while [a.num, b.num, c.num].any? { |n| n == new_label } do
        new_label -= 1
        new_label = @max if new_label < 1
      end
      puts "Actual Label: #{new_label}" if @debug

      new_pos = @nums[new_label]
      segment_end = new_pos.next
      new_pos.next = a
      c.next = segment_end

      @pos = @pos.next
    end
  end

  class Node
    attr_reader :num
    attr_accessor :next

    def initialize(num)
      @next = nil
      @num = num
    end
  end
end
