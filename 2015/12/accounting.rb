require 'set'
require '../lib/grid.rb'
require 'json'

module Advent

  class Accounting
    attr_accessor :debug
    attr_reader :json

    def initialize(input)
      @debug = false
      @json = input.chomp
    end

    def debug!
      @debug = true
    end

    def numbers
      @numbers ||= @json.scan(/([\-\d]+)/).flatten.map(&:to_i)
      # json_numbers
    end

    def json_numbers(obj = JSON.parse(@json), filter = nil)
      nums = []
      # as_json = obj.to_json if @debug
      # binding.pry if @debug && (as_json.include?('199'))
      obj.each do |v|
        # binding.pry if @debug && @break
        return [] if filter && obj.is_a?(Hash) && v.last == filter
        nums << v if v.is_a? Integer
        nums.concat(json_numbers(v, filter)) if v.is_a?(Array) || v.is_a?(Hash)
      end
      puts "Obj: #{obj}\nNums: #{nums}" if @debug #&& obj.to_json.length < 100
      nums
    end

    def non_red_numbers(obj = JSON.parse(@json))
      json_numbers(obj, 'red')
    end
  end
end
