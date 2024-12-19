import queue

def parse(input_text):
  falling_bytes = []
  falling_bytes_map = {}

  max_x = 0
  may_y = 0
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    
    x, y = tuple(map(int,line.split(',')))
    if x > max_x:
      max_x = x
    if y > may_y:
      may_y = y

    # Starts at zeroth-nanosecond
    falling_bytes_map[(x, y)] = len(falling_bytes)
    falling_bytes.append((x, y))

  grid = []

  for y in range(may_y + 1):
    g = []
    for x in range(max_x + 1):
      if (x, y) in falling_bytes:
        # Starts at zeroth-nanosecond
        g.append(falling_bytes.index((x, y)))
      else:
        g.append(None)
    grid.append(g)

  return falling_bytes_map, grid

def render(grid, time):
  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if grid[y][x] == None:
        print('.', end='')
      elif grid[y][x] <= time:
        print('#', end='')
      else:
        print('_', end='')
    print()
  
  print()

def distance(a, b):
  return abs(a[0] - b[0]) + abs(a[1] - b[1])

def pathfinder(fb_map, time_code, s, e):
  best_steps = 99999999

  candidates = queue.PriorityQueue()
  candidates.put((distance(s, e)*3, s, 0))
  visited = {}

  counter = 0
  while not candidates.empty():
    counter += 1
    _, pos, steps = candidates.get()

    if pos in visited:
      if visited[pos] > steps:
        visited[pos] = steps
      else:
        continue
    else:
      visited[pos] = steps

    if pos == e:
      if steps < best_steps:
        best_steps = steps
      continue

    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
      nx, ny = pos
      nx += dx
      ny += dy

      # blocked by bounds of grid
      if nx < 0 or nx > e[0] or ny < 0 or ny > e[1]:
        continue
      # blocked by falling block
      if (nx, ny) in fb_map and fb_map[(nx, ny)] < time_code:
        continue

      # candidates.put((distance((nx, ny), e) + steps, (nx, ny), steps + 1))
      # print(f"Putting: {nx}, {ny}, {steps + 1}")
      candidates.put((distance((nx, ny), e)*3 + steps + 1, (nx, ny), steps + 1))

  print(f"Best Steps: {best_steps} Iterations: {counter}, TC: {time_code}")
  return best_steps

def find_blocker(fb_map, time_code, s, e):
  max_timecode = max(fb_map.values())
  for tc in range(time_code, max_timecode + 1):
    if pathfinder(fb_map, tc, s, e) == 99999999:
      print(f"Found TC: {tc}")
      for k, v in fb_map.items():
        if v == tc - 1:
          return k

def part1(input_text, time_code, s, e):
    fb_map, _ = parse(input_text)
    return pathfinder(fb_map, time_code, s, e)

def part2(input_text, starting_time_code, s, e):
  fb_map, _ = parse(input_text)
  return find_blocker(fb_map, starting_time_code, s, e)

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read(), 1024, (0, 0), (70, 70)))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read(), 1024, (0, 0), (70, 70)))