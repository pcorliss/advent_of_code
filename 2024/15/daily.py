def parse(input_text):
  grid = []
  moves = []
  pos = None

  grid_fill = True
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      if grid != []:
        grid_fill = False
      continue

    if grid_fill:
      grid.append(list(line))

    else:
      moves += list(line)

  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if grid[y][x] == '@':
        grid[y][x] = '.'
        pos = (x, y)

  return (grid, moves, pos)

MOVE_MAP = {
  '<': (-1, 0),
  '>': (1, 0),
  'v': (0, 1),
  '^': (0, -1)
}

def move(grid, pos, moves):
  new_grid = grid # Test that this does a deep copy
  x, y = pos

  for move in moves:
    dx, dy = MOVE_MAP[move]
    n_x = x + dx
    n_y = y + dy
    if new_grid[n_y][n_x] == '#':
      continue

    boxes = []
    while new_grid[n_y][n_x] == 'O':
      boxes.append((n_x, n_y))
      n_x += dx
      n_y += dy

    if new_grid[n_y][n_x] == '#':
      continue

    if len(boxes) > 0:
      bx, by = boxes[0]
      new_grid[by][bx] = '.'
      new_grid[n_y][n_x] = 'O'

    x += dx
    y += dy

    print(f"Move: {move} New Pos: ({x}, {y}), Delta: ({dx}, {dy})")

  return (new_grid, (x, y))

def gps(x, y):
  return x + y * 100

def part1(input_text):
  grid, moves, pos = parse(input_text)
  new_grid, _ = move(grid, pos, moves)
  sum = 0
  for y in range(len(new_grid)):
    for x in range(len(new_grid[y])):
      if new_grid[y][x] == 'O':
        sum += gps(x, y)
  return sum

def part2(input_text):
  sum = 0
  return sum

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))