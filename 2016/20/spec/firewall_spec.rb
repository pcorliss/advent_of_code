require './firewall.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Firewall do
    let(:ad) { Advent::Firewall.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end
end
