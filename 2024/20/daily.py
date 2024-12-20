import itertools

def parse(input_text):
  grid = []
  s = None
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

  return (grid, s, e)

def fill_path(grid, s, e):
  steps = {}
  steps[s] = 0
  pos = s

  step_count = 0
  while pos != e:
    x, y = pos

    for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
      if grid[y+dy][x+dx] == '.' and (x+dx, y+dy) not in steps:
        pos = (x+dx, y+dy)
        steps[pos] = steps[(x, y)] + 1
        break

  return steps

def cheat_options(steps):
  options = []
  for pos, step in steps.items():
    x, y = pos
    for dx, dy in [(-2, 0), (2, 0), (0, -2), (0, 2)]:
      nx, ny = x+dx, y+dy
      if (nx, ny) in steps and steps[(nx, ny)] > step + 2:
        options.append(steps[(nx, ny)] - 2 - step)

  return options

  
def part1(input_text, cheat_threshold=100):
  grid, s, e = parse(input_text)
  steps = fill_path(grid, s, e)
  options = cheat_options(steps)

  return len([o for o in options if o >= cheat_threshold])

def part2(input_text, cheat_threshold=100):
  grid, s, e = parse(input_text)
  steps = fill_path(grid, s, e)

  counter = 0
  for (pos_a, steps_a), (pos_b, steps_b) in itertools.combinations(steps.items(), 2):
    distance = abs(pos_a[0] - pos_b[0]) + abs(pos_a[1] - pos_b[1])
    if distance > 20:
      continue
    diff = abs(steps_a - steps_b)
    if diff - distance >= cheat_threshold:
      counter += 1

  return counter

# Too High - 42297218
# Too low - 947532

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))