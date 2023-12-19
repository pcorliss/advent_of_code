require './workflow.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}
    
    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
    EOS
  }

  describe Advent::Workflow do
    let(:ad) { Advent::Workflow.new(input) }

    describe "#new" do
      it "inits a list of workflows" do
        expect(ad.workflows.count).to eq(11)
        expect(ad.workflows['px']).to eq([['a', :<, 2006, 'qkq'], ['m', :>, 2090, 'A'], ['rfg']])
        expect(ad.workflows['pv']).to eq([['a', :>, 1716, 'R'], ['A']])
      end

      it "inits a list of parts" do
        expect(ad.parts.count).to eq(5)
        expect(ad.parts.first).to eq({'x' => 787, 'm' => 2655, 'a' => 1222, 's' => 2876})
      end
    end

    describe "#process_workflow" do
      let(:part) { ad.parts.first }

      it "processes a workflow" do
        expect(ad.process_workflow(ad.workflows['in'], part)).to eq('qqz')
        expect(ad.process_workflow(ad.workflows['qqz'], part)).to eq('qs')
        expect(ad.process_workflow(ad.workflows['qs'], part)).to eq('lnx')
        expect(ad.process_workflow(ad.workflows['lnx'], part)).to eq('A')
      end
    end

    describe "#accepted_parts" do
      it "returns a list of parts that are accepted by the workflow" do
        expect(ad.accepted_parts.count).to eq(3)
        expect(ad.accepted_parts).to match_array([
          ad.parts[0], ad.parts[2], ad.parts[4]
        ])
      end
    end

    describe "#accepted_parts_sum" do
      it "returns the sum of the accepted parts" do
        expect(ad.accepted_parts_sum).to eq(19114)
      end
    end

    context "validation" do
    end
  end
end
