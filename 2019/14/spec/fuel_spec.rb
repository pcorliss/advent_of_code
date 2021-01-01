require './fuel.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
    EOS
  }

  describe Advent::Fuel do
    let(:ad) { Advent::Fuel.new(input) }

    describe "#new" do
      it "creates a list of chem reactions" do
        expect(ad.conversions.count).to eq(6)
        expect(ad.conversions['A']).to eq({
          quant: 10,
          chem: 'A',
          from: [
            {
              quant: 10,
              chem: 'ORE',
            },
          ]
        })
        expect(ad.conversions['FUEL']).to eq({
          quant: 1,
          chem: 'FUEL',
          from: [
            {
              quant: 7,
              chem: 'A',
            },
            {
              quant: 1,
              chem: 'E',
            },
          ]
        })
      end
    end

    describe "#make_chems" do
      it "takes a list of chems and returns the chems required to make them" do
        expect(ad.make_chems({"FUEL" => 1})).to eq({
          "E" => 1, "A" => 7, spare: {},
        })
      end

      it "handles quantities" do
        expect(ad.make_chems({"FUEL" => 2})).to eq({
          "E" => 2, "A" => 14, spare: {},
        })
      end

      it "shows spares" do
        expect(ad.make_chems({"A" => 12})).to eq({
          "ORE" => 20, spare: {"A" => 8},
        })
        expect(ad.make_chems({"A" => 14, "B" => 2})).to eq({
          "ORE" => 22, spare: {"A" => 6},
        })
      end

      it "takes from spares" do
        expect(ad.make_chems({"A" => 14, "B" => 2, spare: {"A" => 6}})).to eq({
          "ORE" => 12, spare: {"A" => 2},
        })
      end

      it "handles a progression" do
        ret = ad.make_chems({"FUEL" => 1})
        expect(ret).to eq({"A" => 7, "E" => 1, spare: {}})
        ret = ad.make_chems(ret)
        expect(ret).to eq({"D" => 1, "ORE" => 10, "A" => 7, spare: {"A" => 3}})
        ret = ad.make_chems(ret)
        expect(ret).to eq({"C" => 1, "ORE" => 20, "A" => 7, spare: {"A" => 6}})
        ret = ad.make_chems(ret)
        expect(ret).to eq({"B" => 1, "ORE" => 30, "A" => 7, spare: {"A" => 9}})
        ret = ad.make_chems(ret)
        expect(ret).to eq({"ORE" => 31, spare: {"A" => 2}})
        ret = ad.make_chems(ret)
        expect(ret).to eq({"ORE" => 31, spare: {"A" => 2}})
      end
    end

    describe "#base_chems" do
      it "does nothing if there are only base chems being asked about" do
        expect(ad.base_chems("ORE" => 1)).to eq({"ORE" => 1})
      end

      it "uses make_chems to calculate the basic chems required" do
        expect(ad.base_chems({"FUEL" => 1})).to eq({"ORE" => 31, spare: {"A" => 2}})
      end
    end

    context "validation" do
      it "handles more complicated input" do
        input = <<~EOS
        9 ORE => 2 A
        8 ORE => 3 B
        7 ORE => 5 C
        3 A, 4 B => 1 AB
        5 B, 7 C => 1 BC
        4 C, 1 A => 1 CA
        2 AB, 3 BC, 4 CA => 1 FUEL
        EOS
        ad = Advent::Fuel.new(input)
        expect(ad.base_chems({"FUEL" => 1})).to eq({
          "ORE" => 165, :spare => {"B" => 1, "C" => 3},
        })
      end
      it "handles more complicated input" do
        input = <<~EOS
        157 ORE => 5 NZVS
        165 ORE => 6 DCFZ
        44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
        12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
        179 ORE => 7 PSHF
        177 ORE => 5 HKGWZ
        7 DCFZ, 7 PSHF => 2 XJWVT
        165 ORE => 2 GPVTF
        3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
        EOS
        ad = Advent::Fuel.new(input)
        expect(ad.base_chems({"FUEL" => 1})).to include({"ORE" => 13312})
      end
      it "handles more complicated input" do
        input = <<~EOS
        2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
        17 NVRVD, 3 JNWZP => 8 VPVL
        53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
        22 VJHF, 37 MNCFX => 5 FWMGM
        139 ORE => 4 NVRVD
        144 ORE => 7 JNWZP
        5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
        5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
        145 ORE => 6 MNCFX
        1 NVRVD => 8 CXFTF
        1 VJHF, 6 MNCFX => 4 RFSQX
        176 ORE => 6 VJHF
        EOS
        ad = Advent::Fuel.new(input)
        expect(ad.base_chems({"FUEL" => 1})).to include({"ORE" => 180697})
      end
      it "handles more complicated input" do
        input = <<~EOS
        171 ORE => 8 CNZTR
        7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
        114 ORE => 4 BHXH
        14 VRPVC => 6 BMBT
        6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
        6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
        15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
        13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
        5 BMBT => 4 WPTQ
        189 ORE => 9 KTJDG
        1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
        12 VRPVC, 27 CNZTR => 2 XDBXC
        15 KTJDG, 12 BHXH => 5 XCVML
        3 BHXH, 2 VRPVC => 7 MZWV
        121 ORE => 7 VRPVC
        7 XCVML => 6 RJRHP
        5 BHXH, 4 VRPVC => 5 LTCX
        EOS
        ad = Advent::Fuel.new(input)
        expect(ad.base_chems({"FUEL" => 1})).to include({"ORE" => 2210736})
      end
    end
  end
end
