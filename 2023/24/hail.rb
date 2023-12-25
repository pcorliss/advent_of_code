require 'set'
require '../lib/grid.rb'
require '../lib/ring.rb'

module Advent

  class Hail
    attr_accessor :debug
    attr_reader :hail

    def initialize(input)
      @debug = false
      @hail = input.each_line.map do |line|
        pos, vel = line.split('@')
        pos = pos.split(',').map(&:to_i)
        vel = vel.split(',').map(&:to_i)
        [pos, vel]
      end
    end

    def debug!
      @debug = true
    end

    def bind
      require 'pry'
      binding.pry
    end

    def fit_line(hail)
      pos, vel = hail
      x, y, z = pos
      vx, vy, vz = vel
      # 0 = ax + by + c
      a = vy / vx.to_f
      c = y - x * a
      b = -1
      [a, b, c]
    end

    # In the form of
    # 0 = ax + by + c
    def intersection(l1, l2)
      a1, b1, c1 = l1
      a2, b2, c2 = l2
      x = (b1 * c2 - b2 * c1) / (a1 * b2 - a2 * b1)
      y = (a2 * c1 - a1 * c2) / (a1 * b2 - a2 * b1)
      [x, y]
    end

    def in_the_past?(h1, h2, x, y)
      (x1, y1, _), (dx1, dy1, _) = h1
      (x2, y2, _), (dx2, dy2, _) = h2
   
      # binding.pry if @debug
      (x - x1) / dx1 < 0 || (x - x2) / dx2 < 0 ||
        (y - y1) / dy1 < 0 || (y - y2) / dy2 < 0
    end

    def matching_intersections(bounds)
      bx1, by1 = bounds.first
      bx2, by2 = bounds.last

      lines_map = {}
      @hail.each do |hail|
        lines_map[hail] = fit_line(hail)
      end

      count = 0

      @hail.combination(2).each do |h1, h2|
        (x1, _, _), _ = h1
        (x2, _, _), _ = h2
        l1 = lines_map[h1]
        l2 = lines_map[h2]
        x, y = intersection(l1, l2)
        in_bounds = x.between?(bx1, bx2) && y.between?(by1, by2)
        in_past = in_the_past?(h1, h2, x, y)
        no_intersection = x.abs == Float::INFINITY || y.abs == Float::INFINITY

        if @debug
          puts "Hailstone A: #{h1.inspect}"
          puts "Hailstone B: #{h2.inspect}"
          if in_past
            puts "Hailstones' paths crossed in the past."
          elsif no_intersection
            puts "Hailstones' paths will never cross."
          else
            puts "Hailstones' paths will cross #{in_bounds ? 'inside' : 'outside'} the test area (at #{[x,y]})."
          end
          puts ""
        end

        count += 1 if !in_past && in_bounds && !no_intersection
      end

      count
    end

    def find_common_vel(common_vel, idx)
      s = Set.new
      common_vel = common_vel
      poss = @hail.map(&:first)
      common_hail = @hail.select { |a,b| b[idx] == common_vel }
      positions = common_hail.map(&:first)
      positions.map { |pos| pos[idx] }.combination(2).each do |a,b|
        r = s
        r = (-1000..1000) if s.empty?
        subset = r.select do |i|
          next if i == common_vel
          (a - b).abs % (i - common_vel) == 0
        end
        s = subset if s.empty?
        s &= subset
      end
    
      s
    end
  
    # The following heavily influenced by this commenter's solution
    # https://www.reddit.com/r/adventofcode/comments/18pnycy/comment/keqf8uq/?utm_source=reddit&utm_medium=web2x&context=3
    def calc_vel(idx)
      counts = {}
      vels = @hail.map(&:last)
      vels.map { |vel| vel[idx] }.each { |v| counts[v] ||= 0; counts[v] += 1 }
      counts.sort_by { |k,v| v }.reverse.inject(Set.new) do |sum, (vel, count)|
        return sum if count < 2
        if sum.empty?
          sum = find_common_vel(vel, idx)
        else
          sum &= find_common_vel(vel, idx)
        end
      end
    end

    def solve_rock(rvel)
      rvx, rvy, rvz = rvel
      rv = rvx

      (px0, py0, pz0), (vx0, vy0, vz0) = @hail[0]
      (px1, py1, pz1), (vx1, vy1, vz1) = @hail[1]
      (px2, py2, pz2), (vx2, vy2, vz2) = @hail[2]

      m0 = (vy0 - rvy) / (vx0 - rvx).to_f
      m1 = (vy1 - rvy) / (vx1 - rvx).to_f

      c0 = py0 - (m0 * px0)
      c1 = py1 - (m1 * px1)

      rx = ((c1 - c0) / (m0 - m1)).to_i
      ry = ((m0 * rx) + c0).to_i

      t = (rx - px0) / (vx0 - rvx)
      rz = pz0 + (vz0 - rvz) * t

      valid = @hail.each do |(px, py, pz), (vx, vy, vz)|
        next if vx == rvx || vy == rvy || vz == rvz
        tx = (rx - px) / (vx - rvx)
        ty = (ry - py) / (vy - rvy)
        tz = (rz - pz) / (vz - rvz)
        next if tx == ty && ty == tz
        return nil # Invalid Solution
      end

      [rx, ry, rz]
    end

    def full_solve
      rvx_set = calc_vel(0)
      rvy_set = calc_vel(1)
      rvz_set = calc_vel(2)

      rvx_set.each do |rvx|
        rvy_set.each do |rvy|
          rvz_set.each do |rvz|
            rvel = [rvx, rvy, rvz]
            puts "Trying: #{rvel.inspect}" if @debug
            rx, ry, rz = solve_rock(rvel)
            return [rx, ry, rz] unless rx == nil
          end
        end
      end
    end
  end
end
