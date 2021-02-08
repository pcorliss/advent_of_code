require './security.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Security do
    let(:ad) { Advent::Security.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end
end
