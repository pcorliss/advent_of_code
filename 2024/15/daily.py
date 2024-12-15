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

def parse_part_2(input_text):
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
      grid_line = []
      for idx in range(len(line)):
        if line[idx] == '@':
          pos = (idx * 2, len(grid))
          grid_line.append('.')
          grid_line.append('.')
        elif line[idx] == '.':
          grid_line.append('.')
          grid_line.append('.')
        elif line[idx] == '#':
          grid_line.append('#')
          grid_line.append('#')
        elif line[idx] == 'O':
          grid_line.append('[')
          grid_line.append(']')
        else:
          raise(f"Unknown Char {line[idx]}")

      grid.append(grid_line)


    else:
      moves += list(line)


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

    # print(f"Move: {move} New Pos: ({x}, {y}), Delta: ({dx}, {dy})")

  return (new_grid, (x, y))

def render(grid, pos):
  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if (x, y) == pos:
        print('@', end='')
      else:
        print(grid[y][x], end='')
    print()
  
  print()

def move_part_2(grid, pos, moves):
  new_grid = grid # Test that this does a deep copy
  x, y = pos
  counter = 0
  for move in moves:
    # if counter >= 20 and counter <= 22:
    #   print(f"Counter: {counter} Move: {move}")
    counter += 1

    dx, dy = MOVE_MAP[move]
    n_x = x + dx
    n_y = y + dy
    if new_grid[n_y][n_x] == '#':
      continue

    if dy == 0:
      boxes = []
      while new_grid[n_y][n_x] == '[' or new_grid[n_y][n_x] == ']':
        boxes.append((n_x, n_y))
        n_x += dx
        n_y += dy

      if new_grid[n_y][n_x] == '#':
        continue

      if len(boxes) > 0:
        updates = []
        for bx, by in boxes:
          updates.append((bx + dx, by, new_grid[by][bx]))
          new_grid[by][bx] = '.'
        
        for bx, by, char in updates:
          new_grid[by][bx] = char

    else:
      # Vertical movement of boxes is more complicated
      boxes = veritcally_adjacent_boxes(grid, n_x, n_y, dy)
      # if counter >= 20 and counter <= 22:
      #   print(f"Boxes: {boxes}")
      if None in boxes:
        # if counter >= 20 and counter <= 22:
        #   print(f"\tPoison Pill!")
        continue

      updates = []
      for bx, by in boxes:
        updates.append((bx, by + dy, new_grid[by][bx]))
        new_grid[by][bx] = '.'

      # if counter >= 20 and counter <= 22:
      #   print(f"Updates: {updates}")
      for bx, by, char in updates:
        new_grid[by][bx] = char

    x += dx
    y += dy

    # if counter >= 20 and counter <= 22:
    #   print(f"Counter: {counter} Move: {move} New Pos: ({x}, {y}), Delta: ({dx}, {dy})")
    #   render(new_grid, (x, y))

  return (new_grid, (x, y))

# Need to handle a case 
def veritcally_adjacent_boxes(grid, x, y, dy):
  boxes = []
  # print(f"Vert: ({x}, {y}) Dy: {dy}")
  if grid[y][x] == '[':
    # print(f"Vert: ({x}, {y}) Dy: {dy} Char: {grid[y][x]}")
    boxes.append((x, y))
    boxes.append((x + 1, y))
    boxes += veritcally_adjacent_boxes(grid, x, y + dy, dy)
    boxes += veritcally_adjacent_boxes(grid, x + 1, y + dy, dy)
  if grid[y][x] == ']':
    # print(f"Vert: ({x}, {y}) Dy: {dy} Char: {grid[y][x]}")
    boxes.append((x, y))
    boxes.append((x - 1, y))
    boxes += veritcally_adjacent_boxes(grid, x, y + dy, dy)
    boxes += veritcally_adjacent_boxes(grid, x - 1, y + dy, dy)
  if grid[y][x] == '#':
    # print(f"Vert: ({x}, {y}) Dy: {dy} Char: {grid[y][x]} - Poison")
    return [None] # Poison Pill
  return set(boxes)


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
  grid, moves, pos = parse_part_2(input_text)
  new_grid, new_pos = move_part_2(grid, pos, moves)
  render(new_grid, new_pos)
  sum = 0
  for y in range(len(new_grid)):
    for x in range(len(new_grid[y])):
      if new_grid[y][x] == '[':
        sum += gps(x, y)
  return sum

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))