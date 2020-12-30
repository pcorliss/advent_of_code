require './monitoring.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Monitoring do
    let(:ad) { Advent::Monitoring.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end
end
