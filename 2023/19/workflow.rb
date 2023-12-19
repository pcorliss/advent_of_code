require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Workflow
    attr_accessor :debug
    attr_reader :workflows, :parts

    def initialize(input)
      @debug = false
      @parts = []
      @workflows = {}
      input.each_line do |line|
        if line =~ /^{(.*)}$/
          @parts << $1.split(',').map do |part|
            part =~ /([a-z]+)=(\d+)/
            [$1, $2.to_i]
          end.to_h
        elsif line =~ /^([a-z]+){(.*)}$/
          # puts "Line: #{line}"
          @workflows[$1] = $2.split(',').map do |wf|
            # puts "  WF: #{wf}"
            if wf =~ /([a-z]+)([<>])(\d+):([\w]+)/
              # puts "    #{$1} #{$2} #{$3} #{$4}"
              [$1, $2.to_sym, $3.to_i, $4]
            else
              # puts "    #{wf}"
              [wf]
            end
          end
        end
      end
    end

    def debug!
      @debug = true
    end

    def process_workflow(workflow, part)
      workflow.each do |wf|
        if wf.count == 1
          return wf.first
        else
          var, op, val, next_wf = wf
          if part[var].send(op, val)
            return next_wf
          end
        end
      end
      nil
    end

    def accepted_parts
      @parts.select do |part|
        wkfl = 'in'
        while wkfl != 'A' && wkfl != 'R' do
          wkfl = process_workflow(@workflows[wkfl], part)
        end
        wkfl == 'A'
      end
    end

    def accepted_parts_sum
      accepted_parts.sum do |part|
        part.values.sum
      end
    end

    def combos
      ranges = {'x' => (1..4000), 'm' => (1..4000), 'a' => (1..4000), 's' => (1..4000)}
      workflow = 'in'
      branches = [[ranges, workflow]]
      combos = 0

      i = 0
      until branches.empty? do
        branch = branches.pop
        ranges, workflow = branch
        w = nil

        if workflow == 'A'
          puts "Accepted: #{ranges}" if @debug
          combos += ranges.values.inject(1) do |sum, r|
            sum * r.count
          end
          next
        elsif workflow == 'R'
          next
        else
          w = @workflows[workflow]
          puts "WF: #{workflow} -> #{w}, Ranges: #{ranges}" if @debug
        end

        w.each do |wf|
          # Rejected
          puts "  WF: #{wf}, Ranges: #{ranges}" if @debug
          if wf.count == 1
            branches << [ranges, wf.first]
            puts "      New Branch: #{branches.last}" if @debug
          else
            var, op, val, next_wf = wf
            min, max = ranges[var].minmax 
            new_range = ranges.dup
            if op == :<
              new_range[var] = (min..val - 1)
              branches << [new_range, next_wf]
              ranges[var] = (val..max)
            elsif op == :>
              new_range[var] = (val + 1..max)
              branches << [new_range, next_wf]
              ranges[var] = (min..val)
            end

            puts "    New Branch: #{branches.last}, Remaining: #{ranges}" if @debug
          end
        end

        i += 1
        raise "Too many iterations #{i}" if i > 1000
      end

      combos
    end
  end
end
