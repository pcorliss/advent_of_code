#!/usr/bin/env ruby

require_relative 'cryostasis'

require 'readline'

def input(prompt="", newline=false)
  prompt += "\n" if newline
  Readline.readline(prompt, true).squeeze(" ").strip
end

def replay(inp, ad)
  inp.each_char do |char|
    ad.program_input = char.ord
  end
end

def find_combo(ad)
  objs = ["semiconductor", "mutex", "sand", "asterisk", "wreath", "dark matter", "loom"]
  (1..7).each do |len|
    objs.combination(len).each do |combo|
      inp = ""
      combo.each do |obj|
        inp += "take #{obj}\n"
      end

      inp += "east\n"

      combo.each do |obj|
        inp += "drop #{obj}\n"
      end

      inp.each_char do |char|
        ad.program_input = char.ord
      end
      ad.run!

      out = ""
      until ad.outputs && ad.outputs.empty? do
        out << ad.output.chr
      end
      print out
      unless out.include?("Droids on this ship are lighter") || out.include?("Droids on this ship are heavier")
        return combo
      end
    end
  end
end

input = File.read('./input.txt')

ad = Advent::IntCode.new(input)
replay(File.read('save.txt'), ad)
until ad.halted? do
  ad.run!
  until ad.outputs && ad.outputs.empty? do
    print ad.output.chr
  end

  inp = gets
  if inp == "debug!\n"
    require 'pry'
    binding.pry
    next
  end

  if inp == "crack\n"
    combo = find_combo(ad)
    puts "Combo: #{combo}"
    next
  end

  @commands ||= ""
  @commands << inp
  inp.each_char do |char|
    ad.program_input = char.ord
  end
end

# I mapped it backwards :-(
#   N
# E-|-W
#   S

#             Pa
#             |
#             Ob Ho
#             |  |
#             GW-Co
#             |       
# NA--ST--HC  |  F-SC-SL
# |           |       |
# AR--KI--HB-----Eng--Ha St
#                 |   |  |
#                 CQ  SB-WD
#
