require './pulses.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
    EOS
  }

  let(:input_2) {
    <<~EOS
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
    EOS
  }

  describe Advent::Pulses do
    let(:ad) { Advent::Pulses.new(input) }

    describe "#new" do
      it "inits a list of instructions" do
        expect(ad.instructions.count).to eq(5)
        expect(ad.instructions['broadcaster']).to eq([:b, 'a', 'b', 'c'])
        expect(ad.instructions['inv']).to eq([:&, 'a'])
      end

      it "inits state" do
        expect(ad.state['a']).to eq(0)
        expect(ad.state['b']).to eq(0)
        expect(ad.state['c']).to eq(0)
      end

      it "inits state for conjunctions" do
        expect(ad.state['inv']).to eq({'c' => 0})
      end
    end

    describe "#send_pulse" do
      let(:input) {
        <<~EOS
        broadcaster -> a, b
        %a -> aa
        %b -> aa
        %aa -> output
        %ainv -> inv
        %binv -> inv
        &inv -> output
        EOS
      }

      it "broadcasts a pulse  to all outputs" do
        # ad.debug!
        ad.send_pulse('broadcaster', 'button', 0)
        expect(ad.state['a']).to eq(1)
        expect(ad.state['b']).to eq(1)
      end

      context "flip flops" do
        it "flips when a low pulse is sent" do
          ad.send_pulse('a', nil, 0)
          expect(ad.state['a']).to eq(1)
          ad.send_pulse('a', nil, 0)
          expect(ad.state['a']).to eq(0)
        end

        it "does nothing when a high pulse is sent" do
          ad.send_pulse('a', nil, 1)
          expect(ad.state['a']).to eq(0)
        end
      end

      context "conjunctions" do
        it "remembers the state of all inputs" do
          ad.send_pulse('ainv', nil, 0)
          ad.send_pulse('binv', nil, 0)
          expect(ad.state['inv']['ainv']).to eq(1)
          expect(ad.state['inv']['binv']).to eq(1)
        end

        it "sends a high pulse" do
          # ad.debug!
          ad.send_pulse('ainv', nil, 0)
          expect(ad.state['inv']['ainv']).to eq(1)
          expect(ad.state['inv']['binv']).to eq(0)
          expect(ad.out).to eq([1])
        end

        it "sends a low pulse when all inputs are high" do
          # ad.debug!
          ad.send_pulse('ainv', nil, 0)
          ad.send_pulse('binv', nil, 0)
          expect(ad.state['inv']['ainv']).to eq(1)
          expect(ad.state['inv']['binv']).to eq(1)
          expect(ad.out).to eq([1,0])
        end
      end

      # Right now we handle pulses DFS, should we do so with BFS?
    end

    describe "#button!" do
      it "sends a broadcast pulse" do
        expect(ad).to receive(:send_pulse).with('broadcaster', 'button', 0, anything, anything)
        ad.button!
        expect(ad.state['a']).to eq(0)
        expect(ad.state['b']).to eq(0)
        expect(ad.state['c']).to eq(0)
      end

      it "returns the number of pulses" do
        expect(ad.button!).to eq([8,4])
      end

      context "example 2" do
        let(:input) { input_2 }

        it "push once: sets both flip flops to 1 and con remembers high" do
          # ad.debug!
          ad.button!
          expect(ad.state['a']).to eq(1)
          expect(ad.state['b']).to eq(1)
          expect(ad.state['con']).to eq({'a' => 1, 'b' => 1})
          expect(ad.out).to eq([1,0])
        end

        it "push twice: flip-flop a turns off, con remembers a low pulse from module a" do
          # ad.debug!
          2.times { ad.button! }
          expect(ad.state['a']).to eq(0)
          expect(ad.state['b']).to eq(1)
          expect(ad.state['con']).to eq({'a' => 0, 'b' => 1})
          expect(ad.out).to eq([1,0,1])
        end

        it "push thrice: flip-flow a on, b is off" do
          # ad.debug!
          3.times { ad.button! }
          expect(ad.state['a']).to eq(1)
          expect(ad.state['b']).to eq(0)
          expect(ad.state['con']).to eq({'a' => 1, 'b' => 0})
          expect(ad.out).to eq([1,0,1,0,1])
        end

        it "4-times: flip-flow a on, b is off" do
          # ad.debug!
          4.times { ad.button! }
          expect(ad.state['a']).to eq(0)
          expect(ad.state['b']).to eq(0)
          expect(ad.state['con']).to eq({'a' => 0, 'b' => 0})
          expect(ad.out).to eq([1,0,1,0,1,1])
        end
      end
    end

    describe "#pulse_mult" do
      it "returns the number of low pulses times the number of high pulses" do
        expect(ad.pulse_mult(1)).to eq(32)
      end

      it "returns the number of low pulses times the number of high pulses" do
        expect(ad.pulse_mult(1000)).to eq(32000000)
      end

      context "example 2" do
        let(:input) { input_2 }

        it "returns the number of low pulses times the number of high pulses" do
          expect(ad.pulse_mult(1000)).to eq(11687500)
        end
      end
    end

    describe "#rx_cycles" do
      let(:input) { File.read('./input.txt') }

      it "returns the number of cycles to send a low pulse to rx" do
        # ad.debug!
        expect(ad.rx_cycles).to eq(244178746156661)
      end
    end
  end
end
