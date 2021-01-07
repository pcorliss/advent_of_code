require './tractor.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) { File.read('./spec_input.txt') }

  describe Advent::Tractor do
    let(:ad) { Advent::Tractor.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end
end
