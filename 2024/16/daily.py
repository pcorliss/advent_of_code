def parse(input_text):
  grid = []
  s = None
  dir = (1,0)
  e = None

  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue

    grid.append(list(line))

  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if grid[y][x] == 'S':
        s = (x, y)
        grid[y][x] = '.'
      elif grid[y][x] == 'E':
        e = (x, y)
        grid[y][x] = '.'

  graph = build_graph(grid, s, dir, e)

  return (grid, graph, s, dir, e)


def intersection(grid, x, y):
  if grid[y][x] == '.':
    count = 0
    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
      if grid[y+dy][x+dx] == '.':
        count += 1

    if count > 2:
      return True
    
  return False

def build_intersections(grid):
  intersections = set()
  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if intersection(grid, x, y):
        intersections.add((x, y))

  return intersections

TURN_MAP = {
  (-1, 0): (0, -1), # W -> N
  (1, 0): (0, 1), # E -> S
  (0, 1): (-1, 0), # S -> W
  (0, -1): (1, 0) # N -> E
}

def turn(dir, n):
  new_dir = dir
  for i in range(n):
    new_dir = TURN_MAP[new_dir]

  return new_dir

def build_graph(grid, s, s_dir, e):
  s_x, s_y = s
  graph = {}
  intersections = set([s, e])
  intersections.update(build_intersections(grid))

  # Start Pos Eastward Facing
  stack = [(s_x, s_y, (1,0))]
  while stack:
    x, y, dir = stack.pop()
    # Bail if this combo is already in the graph
    if (x, y, dir) in graph:
      continue

    # Add this combo to the graph
    graph[(x, y, dir)] = {}

    stack.append((x, y, turn(dir, 1)))
    stack.append((x, y, turn(dir, 2)))
    stack.append((x, y, turn(dir, 3)))

    dx, dy = dir
    turn_counter = 0
    nx, ny = x, y
    steps = 0
    # print(f"Walking: {nx}, {ny}, {dir}")
    while True:
      nx, ny = nx + dx, ny + dy
      steps += 1

      # print(f"Step: {steps}, Turns: {turn_counter}, Pos: {nx}, {ny}, {(dx, dy)}")

      if (nx, ny) in intersections:
        # print(f"Found intersection: {nx}, {ny}, ({dx}, {dy})... Breaking")
        if (nx, ny, (dx, dy)) in graph[(x, y, dir)]:
          st, tu = graph[(x, y, dir)][(nx, ny, (dx, dy))]
          if tu * 1000 + st > turn_counter * 1000 + steps:
            # print(f"We've found this route before and it was longer. We didn't expect this to happen: graph[{(x, y, dir)}][{(nx, ny, (dx, dy))}] = {(steps, turn_counter)} ")
            graph[(x, y, dir)][(nx, ny, (dx, dy))] = (steps, turn_counter)
        else:
          graph[(x, y, (dx, dy))] = {(nx, ny, (dx, dy)): (steps, turn_counter)}

        stack.append((nx, ny, (dx, dy)))

        break

      # We've run into a wall, back-track look for left or right turns
      # There should be no forking because we're not in an intersection
      if grid[ny][nx] == '#':
        # print(f"Hit wall: {nx}, {ny}, ({dx}, {dy})... Backtracking")
        steps -= 1
        ny -= dy
        nx -= dx

        # Need a check on these turns to make sure we're not covering the same ground
        # Or maybe some way of denoting a path is a dead end

        tx, ty = turn((dx, dy), 1)
        if grid[ny+ty][nx+tx] == '.':
          turn_counter += 1
          dx, dy = tx, ty
          # print(f"Found right turn: {nx}, {ny}, ({dx}, {dy})")
          continue

        tx, ty= turn((dx, dy), 3)
        if grid[ny+ty][nx+tx] == '.':
          turn_counter += 1
          dx, dy = tx, ty
          # print(f"Found left turn: {nx}, {ny}, ({dx}, {dy})")
          continue

        # We've hit a dead end
        # print(f"We've hit a dead end: {nx}, {ny}, ({dx}, {dy})... Breaking")
        break


  return graph


def render(grid, pos):
  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if (x, y) == pos:
        print('@', end='')
      else:
        print(grid[y][x], end='')
    print()
  
  print()

def starts(grid, s, dir):
  out = []
  x, y = s

  for i in range(4):
    t = i
    if i == 3:
      t = 1

    dx, dy = turn(dir, i)
    if grid[y+dy][x+dx] == '.':
      out.append((s, (dx, dy), t * 1000))

  return out

def find_end_path(grid, graph, s, dir, e):
  candidates = starts(grid, s, dir)
  visited = {}
  best_score = None
  intersections = build_intersections(grid)

  while candidates:
    pos, dir, score = candidates.pop()

    if (pos, dir) in visited:
      if visited[(pos, dir)] > score:
        visited[(pos, dir)] = score
      else:
        continue
    else:
      visited[(pos, dir)] = score



    # Walk forward until we hit a wall or an intersection
    dx, dy = dir
    nx, ny = pos
    while True:
      nx, ny = nx + dx, ny + dy
      score += 1
      if (nx, ny) in intersections:
        break
      if grid[ny][nx] == '#':
        nx, ny = nx - dx, ny - dy
        score -= 1
        break

    if (nx, ny) == e:
      if best_score == None or score < best_score:
        best_score = score
      continue

    for pos, dir, score_adj in starts(grid, (nx, ny), dir):
      candidates.append((pos, dir, score + score_adj))
    
  
  return best_score

def part1(input_text):
  grid, graph, s, dir, e = parse(input_text)
  return find_end_path(grid, graph, s, dir, e)

def part2(input_text):
  sum = 0
  return sum

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))