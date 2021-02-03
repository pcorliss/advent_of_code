require './code.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    To continue, please consult the code grid in the manual.  Enter the code at row 4, column 3.
    EOS
  }


  describe Advent::Code do
    let(:ad) { Advent::Code.new(input) }

    describe "#new" do
      it "specifies the grid position" do
        expect(ad.grid_pos).to eq([3,4])
      end
    end

    describe "#grid_n" do
      {
        [1,1] => 1,
        [1,2] => 2,
        [2,1] => 3,
        [1,3] => 4,
        [2,2] => 5,
        [4,1] => 10,
        [4,3] => 19,
        [1,6] => 16,
      }.each do |pos, n|
        it "returns the counter #{n} for a diagonally aligned grid position, #{pos}" do
          expect(ad.grid_n(pos)).to eq(n)
        end
      end
    end

    describe "#code_gen" do
      {
        1 => 20151125,
        2 => 31916031,
        3 => 18749137,
        4 => 16080970,
        5 => 21629792,
        10 => 30943339,
      }.each do |n, code|
        it "returns the #{n} code, #{code}" do
          expect(ad.code_gen(n)).to eq(code)
        end
      end
    end

    context "validation" do
      {
        [1,1] => 20151125,
        [1,2] => 31916031,
        [2,1] => 18749137,
        [6,6] => 27995004,
        [6,5] => 31663883,
      }.each do |pos, code|
        it "returns the proper code #{code} for a specific grid position #{pos}" do
          expect(ad.code_gen(ad.grid_n(pos))).to eq(code)
        end
      end
    end
  end
end
