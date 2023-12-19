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
  end
end
