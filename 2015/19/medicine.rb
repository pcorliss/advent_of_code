require 'set'
require '../lib/grid.rb'

module Advent

  class Medicine
    attr_accessor :debug
    attr_reader :replace, :molecule

    def initialize(input)
      @debug = false
      @replace = {}
      input.each_line do |line|
        line.chomp!
        if line.include? '=>'
          inp, out = line.split(' => ')
          @replace[inp] ||= []
          @replace[inp] << split_molecule(out)
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
      acc = Set.new
      mol.each_with_index do |atom, idx|
        next unless @replace[atom]
        @replace[atom].each do |r|
          new_mol = mol.clone
          new_mol[idx] = r
          acc.add new_mol.flatten
        end
      end

      acc
    end

    def debug!
      @debug = true
    end
  end
end
