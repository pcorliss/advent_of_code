require '../2020.rb'
require 'rspec'

RSpec.describe Advent::One, "#sum" do
  it "returns true" do
    ad = Advent::One.new
    expect(ad.sum).to be_truthy
  end
end
