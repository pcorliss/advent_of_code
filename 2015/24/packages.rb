require 'set'
require '../lib/grid.rb'

module Advent

  class Packages
    attr_accessor :debug
    attr_reader :packages

    def initialize(input)
      @debug = false
      @packages = input.lines.map do |line|
        line.chomp!
        line.to_i
      end
    end

    def debug!
      @debug = true
    end

    def configurations
      target_sum = @packages.sum / 3
      group_a = []
      @packages.length.times do |i|
        group_a = @packages.combination(i).select {|group| group.sum == target_sum}
        puts "Combo: #{i} #{group_a}" if @debug
        break if !group_a.empty?
      end

      group_a
    end

    def configurations_bad
      target_sum = @packages.sum / 3
      ret = []
      seen = Set.new
      # best_length = @packages.length
      @packages.permutation.each do |perm|
        acc = [[],[],[]]
        pos = 0
        running_sum = 0
        perm.each do |val|
          if running_sum == target_sum
            pos += 1
            running_sum = 0
          elsif running_sum > target_sum
            break
          end
          acc[pos] << val
          running_sum += val
        end
        if acc[0].length <= acc[1].length &&
          acc[0].length <= acc[2].length &&
          acc.all? { |group| group.sum == target_sum }
            acc_set = acc.map(&:to_set).to_set
            if !seen.include? acc_set
              ret << acc
              seen.add acc_set
            end
        end
      end
      puts "Ret: #{ret.count}"
      ret
    end
  end
end
