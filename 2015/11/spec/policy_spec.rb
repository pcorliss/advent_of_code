require './policy.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Policy do
    let(:ad) { Advent::Policy.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end
end
