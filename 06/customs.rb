require 'set'

module Advent

  class Six
    attr_reader :forms

    def initialize(input)
      @forms = []
      input.split("\n\n").each do |i|
        @forms.push(Form.new(i))
      end
    end
  end

  class Form
    def initialize(input)
      @input = input
      @answers = Set.new input.gsub(/[^a-z]/, '').each_char
      @unan = nil
      input.each_line do |line|
        yess = Set.new line.chomp.each_char
        @unan = yess if @unan.nil?
        @unan &= yess
      end
    end

    def answer_count
      @answers.count
    end

    def unanimous_count
      @unan.count
    end
  end
end
