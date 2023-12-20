require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Pulses
    attr_accessor :debug
    attr_reader :instructions, :state, :out

    def initialize(input)
      @debug = false
      @state = {}
      @instructions = {}
      input.each_line do |line|
        line.chomp!
        part_info, inputs = line.split(' -> ')
        inputs = inputs.split(', ') if inputs
        inputs ||= []
        part_info =~ /([\%\&]){0,1}(\w+)$/
        type = $1 || 'b'
        name = $2
        @state[name] = 0
        @state[name] = {} if type == '&'
        @instructions[name] = [type.to_sym, *inputs]
      end


      @instructions.each do |name, (t, *outs)|
        outs.each do |out|
          if @instructions[out] && @instructions[out].first == :&
            @state[out][name] = 0
          end
        end
      end

      @reverse_map = {}
      @instructions.each do |name, (t, *outs)|
        outs.each do |out|
          @reverse_map[out] ||= []
          @reverse_map[out] << name
        end
      end
    end

    LOW_HIGH = ['-low', '-high']

    def send_pulse(name, from, value = 0, idx = -1, block = nil)
      puts "#{from} #{LOW_HIGH[value]}-> #{name}" if @debug
      pulse_count = [0, 0]
      queue = [[name, from, value]]

      until queue.empty? do
        n, f, v = queue.shift
        t, *outs = @instructions[n]
        pulse_count[v] += 1

        if block
          block.call(n, f, v, idx)
        end
        # puts "Handling #{t} #{n} from #{f}, received #{v}" if @debug
        # binding.pry if @debug
        case t
        when :b
          outs.each do |out|
            # puts "  Sending #{v} to #{output} from #{n}" if @debug
            puts "#{n} #{LOW_HIGH[v]}-> #{out}" if @debug
            queue << [out, n, v]
          end
        when :%
          if v == 0
            @state[n] ^= 1
            outs.each do |out|
              # puts "  Sending #{@state[n]} to #{out} from #{n}" if @debug
              puts "#{n} #{LOW_HIGH[@state[n]]}-> #{out}" if @debug
              queue << [out, n, @state[n]]
            end
          end
        when :&
          # puts "Received #{value} from #{from} to #{name}" if @debug
          # When a pulse is received,
          # the conjunction module first updates its memory for that input.
          @state[n][f] = v
          # Then, if it remembers high pulses for all inputs, it sends a low pulse;
          # otherwise, it sends a high pulse.
          val = 1
          val = 0 if @state[n].values.all? { |va| va == 1 }
          outs.each do |out|
            # puts "  Sending #{val} to #{out} from #{n}" if @debug
            puts "#{n} #{LOW_HIGH[val]}-> #{out}" if @debug
            queue << [out, n, val]
          end
        else
          if n == 'output'
            @out ||= []
            @out << v
          elsif n == 'rx'
          else
            # raise "Unknown type #{t}"
            puts "WARN: Unknown type #{t} for #{n}" if @debug
          end
        end
      end

      pulse_count
    end

    def button!(idx = -1, &block)
      send_pulse('broadcaster', 'button', 0, idx, block)
    end

    def pulse_mult(cycles)
      sum = [0,0]
      cycles.times do |i|
        low, high = button!
        sum[0] += low
        sum[1] += high
      end
      sum[0] * sum[1]
    end

    def state_diagram
      sd = ''
      sd << "stateDiagram-v2" << "\n"
      @instructions.each do |name, (t, *outs)|
        outs.each do |out|
          sd << "#{name} --> #{out}" << "\n"
        end
      end

      # Output is usable with https://mermaid.live/
      # Reveals a diagram where 4 paths with about 12-bits of state
      # Certain bits need to be on in order to send the right pulse to the aggregator
      sd
    end

    def rx_cycles
      # detect modules that are connected to the rx module
      # Assumes a modules -> aggregator_module -> rx relationship
      aggregator_module = @reverse_map['rx'].first
      feeder_modules = @reverse_map[aggregator_module]
      feeder_cycle_map = feeder_modules.map {|k| [k,0]}.to_h
      i = 0
      until feeder_cycle_map.values.all? { |v| v > 0 } do
        i += 1
        raise "Too many cycles #{i}" if i > 2**12

        # Normally I'd just check the state after pressing the button
        # But the pulse we're looking for gets set and reset in the same cycle
        button!(i) do |name, from, value, idx|
          if value == 1 && name == aggregator_module && feeder_cycle_map[from] == 0
            feeder_cycle_map[from] = idx
          end
        end
      end

      feeder_cycle_map.values.inject(:lcm)
    end

    def debug!
      @debug = true
    end
  end
end
