require './monkey.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
    EOS
  }

  describe Advent::Monkey do
    let(:ad) { Advent::Monkey.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions[:root]).to eq([:pppw, :+, :sjmn])
      end

      it "loads instructions with digits" do
        expect(ad.instructions[:sllz]).to eq([4])
      end
    end

    describe "#lookup" do
      it "returns digits at the root" do
        expect(ad.lookup(:hmdt)).to eq(32)
      end

      it "returns items with math and single nesting" do
        expect(ad.lookup(:drzm)).to eq(30) 
      end

      it "returns multiple nested items" do
        expect(ad.lookup(:root)).to eq(152)
      end
    end

    describe Advent::Monkey::MonkeyNode do
      let(:klass) { Advent::Monkey::MonkeyNode }
      let(:add)   { klass.new(nil, :+, left, right) }
      let(:sub)   { klass.new(nil, :-, left, right) }
      let(:mul)   { klass.new(nil, :*, left, right) }
      let(:div)   { klass.new(nil, :/, left, right) }
      let(:eql)   { klass.new(nil, :==, left, right) }
      let(:left)  { klass.new(3) }
      let(:right) { klass.new(5) }
      let(:human) { klass.new }

      describe "#solve" do
        context "addition" do
          it "handles computing the left side" do
            add.left = human
            add.val = 8
            add.solve!
            expect(human.val).to eq(3)
          end 

          it "handles computing the right side" do
            add.right = human
            add.val = 8
            add.solve!
            expect(human.val).to eq(5)
          end 
        end

        context "subtraction" do
          it "handles computing the left side" do
            sub.left = human
            sub.val = 8
            sub.solve!
            expect(human.val).to eq(13)
          end 

          it "handles computing the right side" do
            sub.right = human
            sub.val = 8
            sub.solve!
            expect(human.val).to eq(-5)
          end 
        end

        context "multiplication" do
          it "handles computing the left side" do
            mul.left = human
            mul.val = 15
            mul.solve!
            expect(human.val).to eq(3)
          end 

          it "handles computing the right side" do
            mul.right = human
            mul.val = 15
            mul.solve!
            expect(human.val).to eq(5)
          end 
        end

        context "division" do
          let(:left)  { klass.new(21) }
          let(:right) { klass.new(7) }

          it "handles computing the left side" do
            div.left = human
            div.val = 3
            div.solve!
            expect(human.val).to eq(21)
          end 

          it "handles computing the right side" do
            div.right = human
            div.val = 3
            div.solve!
            expect(human.val).to eq(7)
          end 
        end

        context "equality" do
          it "handles computing the left side" do
            eql.left = human
            eql.solve!
            expect(human.val).to eq(5)
          end 

          it "handles computing the right side" do
            eql.right = human
            eql.solve!
            expect(human.val).to eq(3)
          end 
        end
      end

      describe "#calc" do
        it "returns the expected value based on children" do
          expect(add.calc).to eq(8)
        end

        it "sets the val" do
          add.calc
          expect(add.val).to eq(8)
        end

        it "returns nil if there's no children and no val" do
          expect(human.calc).to be_nil
        end

        it "returns nil if there's a child that returns nil" do
          add.left = human
          expect(add.calc).to be_nil
        end
      end
    end

    describe "#human" do
      it "returns the number that causes root to pass equality" do
        expect(ad.human).to eq(301)
      end
    end

    context "validation" do
    end
  end
end
