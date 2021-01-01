require 'set'
require '../lib/intcode.rb'
require '../lib/grid.rb'

module Advent

  class Fuel
    attr_accessor :debug
    attr_reader :conversions

    def initialize(input)
      @debug = false
      @conversions = {}
      input.each_line do |line|
        line.chomp!
        from, to = line.split("=>")
        to_quant, to_chem = to.split(' ')
        @conversions[to_chem] = {
          quant: to_quant.to_i,
          chem: to_chem,
          from: []
        }
        from.split(', ').each do |chems|
          quant, chem = chems.split(" ")
          @conversions[to_chem][:from] << {
            quant: quant.to_i,
            chem: chem,
          }
        end
      end
    end

    def debug!
      @debug = true
    end

    def make_chems(chems)
      acc = {}
      acc[:spare] = chems[:spare].clone || {}
      chems.each do |chem, quant|
        next if chem == :spare
        if chem == "ORE"
          acc[chem] ||= 0
          acc[chem] += quant
          next
        end
        conv = @conversions[chem]
        quant_needed = quant
        if acc[:spare][chem]
          spare_quant = acc[:spare][chem]
          if spare_quant >= quant_needed
            acc[:spare][chem] -= quant_needed
            quant_needed = 0
          else
            quant_needed -= acc[:spare][chem]
            acc[:spare][chem] = 0
          end
        end
        batches = quant_needed / conv[:quant]
        rem = quant_needed % conv[:quant]
        if rem > 0
          batches += 1
          acc[:spare][chem] ||= 0
          acc[:spare][chem] += (conv[:quant] - rem)
        end
        conv[:from].each do |comp|
          acc[comp[:chem]] ||= 0
          acc[comp[:chem]] += comp[:quant] * batches
        end
      end
      acc
    end

    def base_chems(chems = {"FUEL" => 1})
      i = 0
      until (chems.keys - ["ORE", :spare]).empty? do
        chems = make_chems(chems)
        i += 1
        raise "Too many iterations!!!" if i > 100
      end
      chems
    end
    # def make_chem(chem, quant = 1, spare = {})
    #   spare = spare.clone
    #   if spare[chem] && spare[chem] >= quant
    #     spare[chem] -= quant
    #     return {
    #       quant: quant,
    #       chem: chem,
    #       from: [],
    #       remainder: spare
    #     }
    #   end
    #   if spare[chem] && spare[chem] < quant
    #     quant -= spare[chem]
    #     spare[chem] = 0
    #   end
    #
    #   conversion = @conversions[chem].clone
    #
    #   conversion[:quant] *= quant
    #   conversion[:from].each do |component|
    #     component[:quant] *= quant
    #   end
    #   conversion[:remainder] = spare
    #   conversion
    # end
    #
  end
end
