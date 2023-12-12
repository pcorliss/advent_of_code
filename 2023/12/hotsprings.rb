require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hotsprings
    attr_accessor :debug
    attr_reader :springs, :counts

    def initialize(input)
      @debug = false

      @springs = []
      @counts = []
      input.lines.each do |line|
        spring, counts = line.split(' ')
        @springs << spring.chars
        @counts << counts.split(',').map(&:to_i)
      end
    end

    def debug!
      @debug = true
    end

    def cont_match?(spring, count)
      spring.join.split('.').reject(&:empty?).map(&:length) == count
    end

    # There's some caching we could do here
    # Could cache segments that have already been computed
    def partial_match?(spring, count)
      cnt = 0
      cnt_idx = 0
      spring.each do |c|
        case c
        when '.'
          next if cnt.zero?
          return false if cnt != count[cnt_idx]
          cnt_idx += 1
          cnt = 0
        when '#'
          cnt += 1
          return false if cnt_idx >= count.length
          return false if cnt > count[cnt_idx]
        when '?'
          return true
        end
      end

      true
    # rescue => e
    #   puts "Failed at #{spring.inspect} #{count.inspect} Error: #{e}"
    #   raise e
    end

    def chomper(spring, count)
      # Prune early if not possible to complete
      return [false] if count.sum + count.length - 1 > spring.length

      cnt = 0
      cnt_idx = 0
      spring.each_with_index do |c, idx|
        case c
        when '.'
          next if cnt.zero?
          return [false] if cnt != count[cnt_idx]
          cnt_idx += 1
          cnt = 0
        when '#'
          cnt += 1
          return [false] if cnt_idx >= count.length
          return [false] if cnt > count[cnt_idx]
        when '?'
          return [true, spring[(idx - cnt)..-1], count[cnt_idx..-1]]
        end
      end

      if cnt > 0
        return [false] if cnt != count[cnt_idx]
        cnt_idx += 1
      end

      # binding.pry if @debug
      if cnt_idx == count.length
        [true, [], []]
      else
        [false]
      end
    end

    # Could change the partial match to a chomper function
    # That just eats the dots and hashes and returns the remaining string, and remaining count
    # memory usage would go down and the speed would go up because we wouldn't have to keep
    # re-checking the full string

    # Could also something like a trie
    # where we store just a character in a node, and the index of the count array
    # then DFS through the tree, increment when we reach bottom, ignore branches that don't match
    def faster_arrangements(spring, count)
      branches = {[spring,count] => 1}
      spring.each_with_index do |c, idx|
        if c == '?'
          new_branches = {}
          branches.each do |(springs, spring_count), branch_count|
            q_idx = springs.index('?')
            dot_spring = springs.dup
            dot_spring[q_idx] = '.'
            hash_spring = springs
            hash_spring[q_idx] = '#'

            ## TODO: Could instead add a counter to the branch when dupes occur
            ## That way we're not processing the same branch multiple times
            ## Could also try setting the key to something faster to calculate instead
            ## of instantiating an array

            m, new_spring, new_count = chomper(dot_spring, spring_count)
            if m
              new_branches[[new_spring, new_count]] ||= 0
              new_branches[[new_spring, new_count]] += branch_count
            end

            m, new_spring, new_count = chomper(hash_spring, spring_count)
            if m
              new_branches[[new_spring, new_count]] ||= 0
              new_branches[[new_spring, new_count]] += branch_count
            end
          end
          branches = new_branches
          puts "Char: #{c}, Idx: #{idx}, Branch Count: #{branches.length}\n\t#{branches.inspect}" if @debug
        end
      end

      possible = branches.sum do |(springs, spring_count), branch_count|
        match, new_spring, new_count = chomper(springs, spring_count)
        if match && new_spring.empty? && new_count.empty?
          branch_count
        else
          0
        end
      end
      puts "Branches: #{branches.length}, Possible: #{possible}" if @debug
      possible
    end

    # Could I make this faster by popping off elements of the count and storing with the branch?
    # I could also use parallel to make this faster
    def fast_arrangements(spring, count)
      # think of it like a giant binary tree,
      # each question mark is a split
      # we prune a branch when partial_match? fails
      # we go breadth first, and hold multiple states in memory
      # At the end we count the number of remaining branches

      branches = [[]]
      spring.each_with_index do |c, idx|
        if c == '?'
          new_branches = []
          branches.each do |branch|
            b = branch.dup << '.'
            new_branches << b if partial_match?(b, count)
            b = branch.dup << '#'
            # binding.pry if @debug && b == ['#', '#']
            new_branches << b if partial_match?(b, count)
          end
          branches = new_branches
        else
          branches.each do |branch|
            branch << c
          end
        end
        # puts "Char: #{c}, Idx: #{idx}, Branches: #{branches.inspect}" if @debug
      end

      possible = branches.count { |b| cont_match?(b, count) }
      # puts "Branches: #{branches.length}, Possible: #{possible}" if @debug
      possible
    end

    def arrangements(spring, count)
      possible = 0
      missing_spaces = spring.count('?')
      puts "Missing spaces: #{missing_spaces} for #{spring} and #{count}" if @debug
      ['.','#'].repeated_permutation(missing_spaces).each do |perm|
        new_spring = spring.map { |c| c == '?' ? perm.shift : c }
        possible += 1 if cont_match?(new_spring, count)
      end
      possible
    end

    def possible_arrangements
      idx = 0
      @springs.zip(@counts).sum do |spring, count|
        s = fast_arrangements(spring, count)
        puts "#{idx}/#{@springs.length} #{spring} #{count} #{s}" if @debug
        idx += 1
        s
      end
    end

    def unfold!
      @springs.map! do |spring|
        5.times.map do |i|
          spring.join
        end.join('?').chars
      end

      @counts.map! do |count|
        5.times.map do |i|
          count
        end.flatten
      end
    end
  end
end
