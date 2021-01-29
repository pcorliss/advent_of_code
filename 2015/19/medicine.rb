require 'set'
require '../lib/grid.rb'

module Advent

  class Medicine
    attr_accessor :debug
    attr_reader :replace, :molecule, :replace_from

    def initialize(input)
      @debug = false
      @replace = {}
      @replace_from = {}
      @rep_cache = {}
      input.each_line do |line|
        line.chomp!
        if line.include? '=>'
          inp, out = line.split(' => ')
          @replace[inp] ||= []
          @replace[inp] << split_molecule(out)
          @replace_from[split_molecule(out)] = inp
        elsif !line.empty?
          @molecule = split_molecule(line)
        end
      end
    end

    def split_molecule(mol)
      acc = []
      mol.each_char do |char|
        if char.upcase == char
          acc << char
        else
          acc[acc.length-1] = acc.last + char
        end
      end
      acc
    end

    def replacements(mol)
      return @rep_cache[mol] if @rep_cache[mol]
      acc = Set.new
      mol.each_with_index do |atom, idx|
        next unless @replace[atom]
        @replace[atom].each do |r|
          new_mol = mol.clone
          new_mol[idx] = r
          acc.add new_mol.flatten
        end
      end

      @rep_cache[mol] = acc
      acc
    end

    def debug!
      @debug = true
    end

    def find_replacement(starting, ending)
      q = {}
      q[1] = replacements(starting)

      i = 1
      loop do
        puts "Checking: #{q[i].count} formula for step #{i}" if @debug
        return i if q[i].include?(ending)
        q[i].each do |rep|
          q[i+1] ||= Set.new
          q[i+1] |= replacements(rep)
        end
        i += 1
        raise "Step Limit Exceeded! #{i}" if i > 100
      end
    end

    def idx_of_arr(arr, search)
      (0..(arr.length - search.length)).each do |i|
        return i if arr.slice(i,search.length) == search
      end
      return -1
    end

    # Initial attempt at part two that required refactoring
    def greedy_backwards(starting)
      working = starting.join('')
      # sorted = @replace_from.keys.sort_by {|k| k.length }
      sorted = @replace_from.keys
      i = 0
      puts "Start: #{i} - #{working}"
      sorted.each do |s|
        while working.include? s.join do
          working = working.sub(s.join,@replace_from[s])
          i += 1
          puts "Step: #{i} - #{working}"
        end
      end
      return i if working == 'e'
      i += greedy_backwards(split_molecule(working))
      i
    end

    # Misguided attempt
    def greedy_from_the_right(starting)
      i = 0
      working = starting.join if starting.is_a? Array
      puts "Start: #{i} - #{working}" if @debug
      sorted = @replace_from.keys.sort_by {|k| k.length }.reverse

      loop do
        ending = sorted.find do |s|
          working.end_with? s.join
        end

        working = working.reverse.sub(ending.join.reverse, @replace_from[ending].reverse).reverse
        return i if working == 'e'
        i += 1
        puts "Step: #{i}-#{ending}-#{working}" if @debug
        raise "Too many iterations #{i}" if i > 100
      end
      i
    end

    # Working attempt but doesn't use randomness
    def greedy_random(starting)
      i = 0
      working = starting.join if starting.is_a? Array
      puts "Start: #{i} - #{working}" if @debug
      
      loop do
        @replace_from.keys.each do |search|
          if working.include? search.join
            working.sub!(search.join, @replace_from[search])
            i += 1
            puts "Step: #{i}-#{search}-#{working}" if @debug
          end
        end
        return i if working == 'e'
        raise "Too many iterations #{i}" if i > 10000
      end
      i
    end
  end
end
