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
      @answers = Set.new input.gsub(/[^a-z]/, '').each_char
    end

    def answer_count
      @answers.count
    end
  end
end
