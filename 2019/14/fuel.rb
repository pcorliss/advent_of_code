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

    # Ideally we'd do an exponential search here but computers are faced so lets be lazy
    def max_fuel_slow
      base_ore = base_chems['ORE']
      puts "Base Ore: #{base_ore}"
      ore_capacity = 1_000_000_000_000
      min_fuel_range = ore_capacity / base_ore
      puts " Fuel Range: #{min_fuel_range}"
      fuel = min_fuel_range
      needed_ore = 0
      while needed_ore < ore_capacity do
        components = base_chems("FUEL" => fuel)
        needed_ore = components["ORE"]
        puts "Fuel: #{fuel} #{needed_ore} #{components}" if @debug
        fuel += 1
      end
      fuel - 1
    end

    def max_fuel
      base_ore = base_chems['ORE']
      puts "Base Ore: #{base_ore}" if @debug
      ore_capacity = 1_000_000_000_000
      min_fuel_range = ore_capacity / base_ore
      puts "Min Fuel Range: #{min_fuel_range}" if @debug
      max_fuel_range = (min_fuel_range * 2).to_i
      fuel = 0
      (min_fuel_range..max_fuel_range).bsearch do |i|
        ore = base_chems("FUEL" => i)['ORE']
        puts "#{i} #{ore}" if @debug
        fuel = i
        ore_capacity - ore
      end
      fuel -= 1 if base_chems("FUEL" => fuel)['ORE'] > ore_capacity
      fuel
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
