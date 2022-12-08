require './filesystem.rb'
require 'rspec'
require 'pry'

describe Advent do

  let(:input) {
    <<~EOS
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
    EOS
  }

  describe Advent::File do
    let(:ad) { Advent::Filesystem.new(input) }
    let(:root) { ad.file_system('/') }

    describe "#calc_size" do
      it "returns the sum of the children files" do
        dir = ad.file_system('/d')
        expect(dir.calc_size).to eq(24933642)
      end

      it "returns the sum of nested children files" do
        dir = ad.file_system('/a')
        expect(dir.calc_size).to eq(94853)
      end

      it "returns the sum of everything from the root" do
        dir = ad.file_system('/')
        expect(dir.calc_size).to eq(48381165)
      end
    end
  end

  describe Advent::Filesystem do
    let(:ad) { Advent::Filesystem.new(input) }

    describe "#new" do
      it "loads instructions" do
        expect(ad.instructions.count).to eq(23)
      end
    end

    describe "#file_system" do
      it "builds the root level directories" do
        dir = ad.file_system('/')
        dirs = dir.children.select(&:dir?)
        expect(dirs.map(&:name)).to contain_exactly('a', 'd')
      end

      it "handles files at the root level" do
        dir = ad.file_system('/')
        files = dir.children.select(&:file?)
        expect(files.map(&:name)).to contain_exactly('b.txt', 'c.dat')
        expect(files.map(&:size)).to contain_exactly(14848514, 8504156)
      end

      it "handles a singly nested directory" do
        dir = ad.file_system('/a')
        dirs = dir.children.select(&:dir?)
        expect(dirs.map(&:name)).to contain_exactly('e')
      end

      it "handles multiple nesting" do
        dir = ad.file_system('/a/e')
        files = dir.children
        expect(files.count).to eq(1)
        expect(files.first.name).to eq('i')
        expect(files.first.size).to eq(584)
      end

      it "handles direct file access" do
        file = ad.file_system('/a/e/i')
        expect(file.name).to eq('i')
        expect(file.size).to eq(584)
      end
    end

    describe "#find_small_dirs" do
      it "returns directories smaller than the max size" do
        dirs = ad.find_small_dirs(100000)
        expect(dirs.map(&:name)).to contain_exactly('a', 'e')
      end
    end
  end
end
