import sys

sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(line))
  return out

def guard_pos(grid):
  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if grid[y][x] == '^':
        return x, y

delta_map = {
  'v': (0, 1),
  '^': (0, -1),
  '>': (1, 0),
  '<': (-1, 0),
}

turn_map = {
  (1, 0): (0, 1),
  (-1, 0): (0, -1),
  (0, -1): (1, 0),
  (0, 1): (-1, 0),
}

def render_grid(grid):
  for line in grid:
    print(''.join(line))
  print()

def position_dir_set(grid, x, y, d_x, d_y):
  positions = set([(x,y)])
  position_dir = set([(x, y, d_x, d_y)])
  # print(f"Positions: {len(positions)} {positions}")
  while True:
    new_x = x + d_x
    new_y = y + d_y

    if new_x < 0 or new_x >= len(grid[0]) or new_y < 0 or new_y >= len(grid):
      # We're off the grid break
      return [positions, position_dir, False]
    

    if grid[new_y][new_x] == '#':
      d_x, d_y = turn_map[(d_x, d_y)]
    else:
      x, y = new_x, new_y

    if (x, y, d_x, d_y) in position_dir:
      # We're in a loop break
      return [positions, position_dir, True]

    # grid[y][x] = 'X'
    positions.add((x, y))
    position_dir.add((x, y, d_x, d_y))
    # print(f"Positions: {len(positions)} {positions}")
    # render_grid(grid)
    # print("")
    # print("")


def part1(input_text):
  grid = parse(input_text)
  x, y = guard_pos(grid)
  d_x, d_y = delta_map[grid[y][x]]
  return len(position_dir_set(grid, x, y, d_x, d_y)[0])

def part2(input_text):
  grid = parse(input_text)
  g_x, g_y = guard_pos(grid)
  gd_x, gd_y = delta_map[grid[g_y][g_x]]
  _, position_dir, _ = position_dir_set(grid, g_x, g_y, gd_x, gd_y)
  new_barriers = set()
  for x, y, d_x, d_y in position_dir:
    # if the space in front is open and the space to the right is open
    # see if we can get ourselves into a loop
    new_x = x + d_x
    new_y = y + d_y
    if new_y >= 0 and new_y < len(grid) and new_x >= 0 and new_x < len(grid[y]) and grid[new_y][new_x] != '#':
      r_x, r_y = turn_map[(d_x, d_y)]
      previous_grid_val = grid[new_y][new_x]
      grid[new_y][new_x] = '#'
      _, _, loop = position_dir_set(grid, g_x, g_y, gd_x, gd_y)
      if loop:
        new_barriers.add((new_x, new_y))
        grid[new_y][new_x] = 'O'
      else:
        grid[new_y][new_x] = previous_grid_val


  # render_grid(grid)
  return len(new_barriers)

print(part1(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part1(file.read()))

print(part2(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part2(file.read()))

# 1833 - Not the right answer