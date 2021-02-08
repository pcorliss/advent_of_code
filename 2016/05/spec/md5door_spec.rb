require './md5door.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    EOS
  }

  describe Advent::Md5door do
    let(:ad) { Advent::Md5door.new(input) }

    describe "#new" do
    end

    context "validation" do
    end
  end
end
