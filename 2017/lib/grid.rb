class Grid
  attr_accessor :width, :height
  attr_accessor :cells, :pos

  X = 0
  Y = 1

  def initialize(init = nil, width = nil, height = nil)
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
      @height = height
    end
    if init.is_a?(String) && width.nil?
      @width = init.lines.first.chomp.length
      y = 0
      init.lines do |line|
        x = 0
        line.chomp.chars.each do |val|
          @cells[[x,y]] = val
          x += 1
        end
        y += 1
      end
      @height = y
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

  def render(pad = 0)
    min_y, max_y = @cells.keys.map(&:last).minmax
    min_x, max_x = @cells.keys.map(&:first).minmax
    max_val_width = @cells.values.map(&:to_s).map(&:length).max
    max_val_width += pad

    puts "Grid: #{@cells}" if @debug
    puts "Cells: #{@cells.keys}" if @debug
    puts "[#{min_x},#{min_y}] -> [#{max_x},#{max_y}]" if @debug
    acc = ""
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        cell = @cells[[x,y]] || ' '
        str = cell.to_s
        padding = ' '*(max_val_width - str.length)
        acc << padding
        acc << str
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

  def box!(start, finish, val = nil, operator = nil)
    x_start, y_start = start
    x_finish, y_finish = finish

    (x_start..x_finish).each do |x|
      (y_start..y_finish).each do |y|
        new_pos = [x,y]
        if operator
          @cells[new_pos] ||= 0
          @cells[new_pos] = @cells[new_pos].__send__(operator, val)
        elsif val.nil?
          @cells[new_pos] = yield(@cells[new_pos])
        else
          @cells[new_pos] = val
        end
      end
    end
  end

  CARDINAL_DIRECTIONS = [
    [-1, 0], # West
    [ 1, 0], # East
    [ 0,-1], # North
    [ 0, 1], # South
  ]

  DIAGONAL_DIRECTIONS = [
    [-1, 0], # West
    [ 1, 0], # East
    [ 0,-1], # North
    [ 0, 1], # South
    [-1,-1], # NorthWest
    [ 1,-1], # NorthEast
    [-1, 1], # SouthWest
    [ 1, 1], # SouthEast
  ]

  def neighbor_coords(cell, diagonals = false)
    directions = CARDINAL_DIRECTIONS
    directions = DIAGONAL_DIRECTIONS if diagonals
    directions.map do |dir|
      [cell[X] + dir[X], cell[Y] + dir[Y]]
    end
  end

  def neighbors(cell, diagonals = false)
    transformed = neighbor_coords(cell, diagonals)
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

  def rotate
    grid = Grid.new
    grid.height = @height
    grid.width = @width
    i = 0
    @width.times do |x|
      (@height - 1).downto(0) do |y|
        grid[(i % @width),(i / @width)] = @cells[[x,y]]
        i += 1
      end
    end
    grid
  end

  def flip(vertically: false)
    grid = Grid.new
    grid.height = @height
    grid.width = @width
    i = 0
    if vertically
      (@height - 1).downto(0) do |y|
        @width.times do |x|
          grid[(i % @width),(i / @width)] = @cells[[x,y]]
          i += 1
        end
      end
    else
      @height.times do |y|
        (@width - 1).downto(0) do |x|
          grid[(i % @width),(i / @width)] = @cells[[x,y]]
          i += 1
        end
      end
    end
    grid
  end

  def split(dim)
    grids = []
    (@height / dim).times do |section_y|
      (@width / dim).times do |section_x|
        g = Grid.new
        g.width = dim
        g.height = dim
        grids << g

        min_x = section_x * dim
        max_x = min_x + dim - 1
        min_y = section_y * dim
        max_y = min_y + dim - 1

        i = 0
        (min_y..max_y).each do |y|
          (min_x..max_x).each do |x|
            g[(i % dim),(i / dim)] = @cells[[x,y]]
            i += 1
          end
        end
      end
    end
    grids
  end

  def self.join(grids)
    dim = Math.sqrt(grids.length).to_i
    g = Grid.new
    sub_grid_w = grids.first.width
    g.width = dim * sub_grid_w
    g.height = g.width
    grids.each_with_index do |grid, idx|
      x_offset = (idx % dim) * sub_grid_w
      y_offset = (idx / dim) * sub_grid_w
      grid.cells.each do |cell, val|
        x, y = cell
        g[x + x_offset, y + y_offset] = val
      end
    end
    g
  end
end
