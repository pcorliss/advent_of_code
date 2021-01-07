class Grid
  attr_accessor :width
  attr_accessor :cells, :pos

  X = 0
  Y = 1

  def initialize(init = nil, width = nil)
    @debug = false
    @cells = {}
    @pos = [0,0]
    if init && width
      @width = width
      init.each_with_index do |val, idx|
        x = idx % width
        y = idx / width
        @cells[[x, y]] = val
      end
    end
    if init.is_a?(String) && width.nil?
      @width = init.lines.first.length - 1
      y = 0
      init.lines do |line|
        x = 0
        line.chomp.chars.each do |val|
          @cells[[x,y]] = val
          x += 1
        end
        y += 1
      end
    end
  end

  def debug!
    @debug = true
  end

  def cell_direction
    directions = {}
    @cells.each do |cell_a, val_a|
      @cells.each do |cell_b, val_b|
        next if cell_a == cell_b
        x = cell_a[X] - cell_b[X]
        y = cell_a[Y] - cell_b[Y]
        atan = Math.atan2(x, y)

        directions[cell_a] ||= {}
        directions[cell_a][atan] ||= []
        directions[cell_a][atan] << cell_b
      end
    end
    directions
  end

  def render
    min_y, max_y = @cells.keys.map(&:last).minmax
    min_x, max_x = @cells.keys.map(&:first).minmax

    puts "Grid: #{@cells}" if @debug
    puts "Cells: #{@cells.keys}" if @debug
    puts "[#{min_x},#{min_y}] -> [#{max_x},#{max_y}]" if @debug
    acc = ""
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        cell = @cells[[x,y]] || ' '
        acc << cell.to_s
      end
      acc << "\n"
    end
    acc.chomp!
    acc
  end

  def draw!(direction, distance, val = true, operator = nil)
    x, y = direction
    distance.times do |i|
      new_pos = [@pos[X] + x, @pos[Y] + y]
      if @cells[new_pos].nil?
        @cells[new_pos] = val
      else
        if operator
          @cells[new_pos] = @cells[new_pos].__send__(operator, val)
        else
          @cells[new_pos] = val
        end
      end
      @pos = new_pos
    end
  end

  def trace!(direction, distance, val)
    x, y = direction
    counter = val
    distance.times do |i|
      counter = val + i + 1
      new_pos = [@pos[X] + x, @pos[Y] + y]
      @cells[new_pos] ||= 0
      @cells[new_pos] += counter
      @pos = new_pos
    end
    counter
  end

  CARDINAL_DIRECTIONS = [
    [-1, 0],
    [ 1, 0],
    [ 0,-1],
    [ 0, 1],
  ]

  def neighbors(cell)
    transformed = CARDINAL_DIRECTIONS.map do |dir|
      [cell[X] + dir[X], cell[Y] + dir[Y]]
    end
    @cells.slice(*transformed)
  end

  def get(pos_x, pos_y = nil)
    pos_x, pos_y = pos_x if pos_x.is_a? Array
    @cells[[pos_x, pos_y]]
  end

  def [](pos_x, pos_y = nil)
    get(pos_x, pos_y)
  end

  def []=(pos_x, pos_y = nil, val=nil)
    if pos_x.is_a? Array
      val = pos_y
      pos_x, pos_y = pos_x
    end
    @cells[[pos_x, pos_y]] = val
  end

  def find(val)
    cell = @cells.find do |cell, v|
      v == val
    end
    cell.first unless cell.nil?
  end

  def find_all(val)
    cells = @cells.find_all do |cell, v|
      v == val
    end
    cells.map(&:first)
  end
end
