require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class File
    attr_reader :name, :size, :parent
    attr_reader :children

    def initialize(name, parent = nil, size = nil)
      @name = name
      @size = size
      @children = []
      @parent = parent
    end

    def type
      size.nil? ? :dir : :file
    end

    def dir?
      type == :dir
    end

    def file?
      type == :file
    end

    def calc_size
      @calc_size ||= @children.sum do |child|
        if child.file?
          child.size
        else
          child.calc_size
        end
      end
    end
  end

  class Filesystem
    attr_accessor :debug
    attr_reader :instructions

    def initialize(input)
      @debug = false
      @instructions = input.lines.map(&:chomp)
    end

    def debug!
      @debug = true
    end
   
    def load_fs!
      @root = File.new('/')
      cwd = @root
      @instructions.each do |inst|
        if inst.start_with? /\d/
          size, name = inst.split(' ')
          cwd.children << File.new(name, cwd, size.to_i)
        end
        if inst.start_with? 'dir'
          x, name = inst.split(' ')
          cwd.children << File.new(name, cwd)
        end
        if inst.start_with? '$ cd '
          x, x, name = inst.split(' ')
          if name == '..'
            cwd = cwd.parent
          elsif name == '/'
            cwd = @root
          else
            child = cwd.children.find do |c|
              c.type == :dir && c.name == name
            end
            if child.nil?
              binding.pry
              raise
            end
            cwd = child
          end
        end
      end
    end

    def file_system(path)
      load_fs!
      parts = path.split('/')
      parts.reject!(&:empty?)
      cwd = @root
      parts.each do |part|
        cwd = cwd.children.find do |c|
          c.name == part
        end
        if cwd.nil?
          binding.pry
          raise "Unable to find #{path}" if cwd.nil?
        end
      end
      cwd
    end

    def find_small_dirs(max_size)
      cwd = file_system('/')
      dirs = []
      candidates = [cwd]
      until candidates.empty?
        candidate = candidates.pop
        if candidate.calc_size < max_size
          dirs << candidate
        end
        candidates.concat candidate.children.select(&:dir?) 
      end

      dirs
    end
  end
end
