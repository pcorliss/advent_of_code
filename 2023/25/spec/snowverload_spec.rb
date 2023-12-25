require './snowverload.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    jqt: rhn xhk nvd
    rsh: frs pzl lsr
    xhk: hfx
    cmg: qnr nvd lhk bvb
    rhn: xhk bvb hfx
    bvb: xhk hfx
    pzl: lsr hfx nvd
    qnr: nvd
    ntq: jqt hfx bvb xhk
    nvd: lhk
    lsr: lhk
    rzs: qnr cmg lsr rsh
    frs: qnr lhk lsr
    EOS
  }

  let(:state_diagram) {
    <<~EOS
    flowchart TD
    jqt --- rhn
    jqt --- xhk
    jqt --- nvd
    rsh --- frs
    rsh --- pzl
    rsh --- lsr
    xhk --- hfx
    cmg --- qnr
    cmg --- nvd
    cmg --- lhk
    cmg --- bvb
    rhn --- xhk
    rhn --- bvb
    rhn --- hfx
    bvb --- xhk
    bvb --- hfx
    pzl --- lsr
    pzl --- hfx
    pzl --- nvd
    qnr --- nvd
    ntq --- jqt
    ntq --- hfx
    ntq --- bvb
    ntq --- xhk
    nvd --- lhk
    lsr --- lhk
    rzs --- qnr
    rzs --- cmg
    rzs --- lsr
    rzs --- rsh
    frs --- qnr
    frs --- lhk
    frs --- lsr
    EOS
  }

  describe Advent::Snowverload do
    let(:ad) { Advent::Snowverload.new(input) }

    describe "#new" do
      it "inits a component map" do
        expect(ad.components['jqt']).to eq(%w(rhn xhk nvd))
      end

      it "inits a connection map" do
        expect(ad.conns['jqt']).to contain_exactly(*(%w(rhn xhk nvd ntq)))
      end

      it "inits a node list" do
        expect(ad.nodes).to contain_exactly(*(%w(jqt rhn xhk nvd ntq rsh frs pzl lsr qnr cmg bvb hfx lhk rzs)))
      end
    end

    describe "#state_diagram" do
      it "returns a mermaid state diagram" do
        expect(ad.state_diagram).to eq(state_diagram)
      end
    end

    describe "#maximize_groups" do
      it "returns the maximized two groups" do
        # ad.debug!
        expect(ad.maximize_groups(cuts: 3)).to contain_exactly(9,6)
      end
    end

    describe "#group_count" do
      it "returns the number of nodes in each group when there are no cuts" do
        expect(ad.group_count([])).to eq([15,0])
      end

      it "returns the number of nodes in each group when there is three cut" do
        expect(ad.group_count([
          %w(hfx pzl),
          %w(bvb cmg),
          %w(nvd jqt),
        ])).to contain_exactly(9,6)
      end
    end

    describe "#find_common_paths" do
      it "top 3 common paths between nodes" do
        # ad.debug!
        expect(ad.find_common_paths()).to contain_exactly(
          %w(hfx pzl).sort,
          %w(bvb cmg).sort,
          %w(nvd jqt).sort,
        )
      end
    end

    context "validation" do
    end
  end
end
