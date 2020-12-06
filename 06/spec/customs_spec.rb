require '../customs.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
      abc

      a
      b
      c

      ab
      ac

      a
      a
      a
      a

      b
    EOS
  }
  let(:ad) { Advent::Six.new(input) }

  describe Advent::Six do
    describe "#new" do
      it "creates a collections of forms" do
        expect(ad.forms.count).to eq(5)
        expect(ad.forms.first).to be_a(Advent::Form)
      end
    end

    context "validation" do
    end
  end

  describe Advent::Form do
    describe "#answer_count" do
      it "returns a number with the number of unique yes answers" do
        [3 , 3 , 3 , 1 , 1 ].each_with_index do |e, idx|
          expect(ad.forms[idx].answer_count).to eq(e)
        end
      end
    end
  end
end
