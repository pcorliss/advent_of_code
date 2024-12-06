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

def part1(input_text):
  grid = parse(input_text)
  x, y = guard_pos(grid)
  d_x, d_y = delta_map[grid[y][x]]
  positions = set([(x,y)])
  # print(f"Positions: {len(positions)} {positions}")
  while True:
    new_x = x + d_x
    new_y = y + d_y

    if new_x < 0 or new_x >= len(grid[0]) or new_y < 0 or new_y >= len(grid):
      return len(positions)

    if grid[new_y][new_x] == '#':
      d_x, d_y = turn_map[(d_x, d_y)]
    else:
      x, y = new_x, new_y

    grid[y][x] = 'X'
    positions.add((x, y))
    # print(f"Positions: {len(positions)} {positions}")
    # render_grid(grid)
    # print("")
    # print("")


def part2(input_text):
  pass

print(part1(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part1(file.read()))

print(part2(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part2(file.read()))