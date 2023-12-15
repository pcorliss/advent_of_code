require './lens.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    EOS
  }

  describe Advent::Lens do
    let(:ad) { Advent::Lens.new(input) }

    describe "#new" do
      it "inits a list of strings/commands" do
        expect(ad.commands).to eq([
          'rn=1',
          'cm-',
          'qp=3',
          'cm=2',
          'qp-',
          'pc=4',
          'ot=9',
          'ab=5',
          'pc-',
          'pc=6',
          'ot=7'
        ])
      end

      it "inits 256 boxes" do
        expect(ad.boxes.length).to eq(256)
      end
    end

    describe "#hashing" do
      it "Hashes a string into an integer" do
        expect(ad.hashing('HASH')).to eq(52)
      end
    end

    describe "#command_hash_sum" do
      it "returns the sum of hashing all the commands" do
        expect(ad.command_hash_sum).to eq(1320)
      end
    end

    describe "#run_command" do
      context "adding a lens" do
        # If the operation character is an equals sign (=),
        # it will be followed by a number indicating the focal length of the lens
        # that needs to go into the relevant box;
        it "inserts a lens into a box" do
          ad.run_command('rn=1')
          expect(ad.boxes[0]).to eq([['rn', 1]])
        end

        # If there is already a lens in the box with the same label,
        # replace the old lens with the new lens:
        it "replaces a lens in a box" do
          ad.run_command('rn=1')
          ad.run_command('rn=2')
          expect(ad.boxes[0]).to eq([['rn', 2]])
        end

        # If there is not already a lens in the box with the same label,
        # add the lens to the box immediately behind any lenses already in the box.
        it "adds a new lens to the end" do
          ad.run_command('rn=1')
          ad.run_command('cm=2')
          expect(ad.boxes[0]).to eq([['rn', 1], ['cm', 2]])
        end
      end

      context "removing a lens" do
        # If the operation character is a dash (-),
        # go to the relevant box and remove the lens with the given label
        it "removes a lens from a box" do
          ad.run_command('rn=1')
          ad.run_command('rn-')
          expect(ad.boxes[0]).to be_empty
        end

        # if it is present in the box.
        it "does nothing if the lens is not present in the box" do
          ad.run_command('rn-')
          expect(ad.boxes[0]).to be_empty
        end
      end
    end

    describe "#run_all_commands" do
      it "runs all the commands" do
        ad.run_all_commands
        # Box 0: [rn 1] [cm 2]
        # Box 3: [ot 7] [ab 5] [pc 6]
        expect(ad.boxes[0]).to eq([['rn', 1], ['cm', 2]])
        expect(ad.boxes[3]).to eq([['ot', 7], ['ab', 5], ['pc', 6]])
      end
    end


    describe "#focusing_power" do
      it "returns the focusing power of all the lenses" do
        ad.run_all_commands
        expect(ad.focusing_power).to eq(145)
      end
    end


    context "validation" do
      # The result of running the HASH algorithm on the label indicates
      # the correct box for that step
      describe "box decisions" do
        [0,0,1,0,1,3,3,3,3,3,3].each_with_index do |expected_box, idx|
          it "returns the expected box #{expected_box} for command #{idx}" do
            label, _ = ad.commands[idx].split(/[^\w]/)
            expect(ad.hashing(label)).to eq(expected_box)
          end
        end
      end
    end
  end
end
