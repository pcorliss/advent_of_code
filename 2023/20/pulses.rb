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
    end

    LOW_HIGH = ['-low', '-high']

    def send_pulse(name, from, value = 0)
      puts "#{from} #{LOW_HIGH[value]}-> #{name}" if @debug
      pulse_count = [0, 0]
      queue = [[name, from, value]]

      until queue.empty? do
        n, f, v = queue.shift
        t, *outs = @instructions[n]
        pulse_count[v] += 1
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
          else
            # raise "Unknown type #{t}"
            puts "WARN: Unknown type #{t} for #{n}" if @debug
          end
        end
      end

      pulse_count
    end

    def button!
      send_pulse('broadcaster', 'button', 0)
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

    def debug!
      @debug = true
    end
  end
end
