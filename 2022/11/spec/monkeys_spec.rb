require './monkeys.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
    EOS
  }

  describe Advent::Monkeys do
    let(:ad) { Advent::Monkeys.new(input) }

    describe "#new" do
      it "instantiates monkeys" do
        expect(ad.monkeys.count).to eq(4)
      end

      it "sets the items each monkey starts with" do
        expect(ad.monkeys[2].items).to eq([79,60,97])
      end

      [
        [1, 19], #Mult
        [0, 6], #Add
        [4, 16], # Square
        [0, 3], # Add
      ].each_with_index do |kv, idx|
        it "defines a monkey operation #{kv.first} => #{kv.last} for monkey #{idx}" do
          expect(ad.monkeys[idx].operate(kv.first)).to eq(kv.last)
        end
      end

      [
        [23, 2, 3],
        [19, 2, 0],
        [13, 1, 3],
        [17, 0, 1],
      ].each_with_index do |kv, idx|
        div, t, f = kv
        it "Monkey #{idx} throws to monkey #{t} when divisible by #{div}" do
          expect(ad.monkeys[idx].throw(div*4)).to eq(t)
        end

        it "Monkey #{idx} throws to monkey #{f} when not divisible by #{div}" do
          expect(ad.monkeys[idx].throw(div*4 + 1)).to eq(f)
        end
      end
    end

    describe "#process_monkey!" do
      it "throws it's items to monkey 3" do
        ad.process_monkey!(ad.monkeys.first)
        expect(ad.monkeys.first.items).to be_empty
        expect(ad.monkeys.last.items.count).to eq(3)
      end

      it "manipulates the item value" do
        ad.process_monkey!(ad.monkeys.first)
        expect(ad.monkeys.last.items).to eq([74,500,620])
      end
      
      it "increments a counter for each item it inspects" do
        ad.process_monkey!(ad.monkeys.first)
        expect(ad.monkeys.first.inspected).to eq(2)
      end
    end

    describe "#process_round!" do
      it "processes all monkeys" do
        ad.process_round!
        expect(ad.monkeys[0].items).to eq([20, 23, 27, 26])
        expect(ad.monkeys[1].items).to eq([2080, 25, 167, 207, 401, 1046])
        expect(ad.monkeys[2].items).to be_empty
        expect(ad.monkeys[3].items).to be_empty
      end
    end


    context "validation" do
      context "after 20 rounds" do
        before do
          20.times { ad.process_round! }
        end

        it "processes multuple rounds" do
          expect(ad.monkeys[0].items).to eq([10, 12, 14, 26, 34])
          expect(ad.monkeys[1].items).to eq([245, 93, 53, 199, 115])
          expect(ad.monkeys[2].items).to be_empty
          expect(ad.monkeys[3].items).to be_empty
        end

        it "inspects items" do
          expect(ad.monkeys[0].inspected).to eq(101)
          expect(ad.monkeys[1].inspected).to eq(95)
          expect(ad.monkeys[2].inspected).to eq(7)
          expect(ad.monkeys[3].inspected).to eq(105)
        end

        describe "#monkey_business" do
          it "returns monkey business" do
            expect(ad.monkey_business).to eq(10605)
          end
        end
      end
    end
  end
end
