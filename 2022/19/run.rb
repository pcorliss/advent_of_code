#!/usr/bin/env ruby

require_relative 'ore'

input = File.read('./input.txt')

ad = Advent::Ore.new(input)
ad.debug!
puts ad.quality_levels

# 1211 - too low.
# 1155 - after refactoring :-(
# 1211 - after adding bounds - much faster
# 1340 - after removing some score pruning
# 1365 was correct - had to remove the pruning and short-circuit