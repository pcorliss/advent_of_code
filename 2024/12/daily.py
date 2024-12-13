import itertools
import sys

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(line))

  return out

CARDINALS = [(0, 1), (0, -1), (1, 0), (-1, 0)]

def blocks(grid, x, y):
  block = set()
  block.add((x, y))
  char = grid[y][x]

  candidates = [(x, y)]
  while len(candidates) > 0:
    x, y = candidates.pop()
    for dx, dy in CARDINALS:
      new_x = x + dx
      new_y = y + dy
      if new_x < 0 or new_x >= len(grid[0]) or new_y < 0 or new_y >= len(grid):
        continue
      if (new_x, new_y) in block:
        continue
      if grid[new_y][new_x] == char:
        block.add((new_x, new_y))
        candidates.append((new_x, new_y))

  return block

def perimeter(grid, block):
  sum = 0
  for x, y in block:
    for dx, dy in CARDINALS:
      new_x = x + dx
      new_y = y + dy
      # Grid Border
      if new_x < 0 or new_x >= len(grid[0]) or new_y < 0 or new_y >= len(grid):
        sum += 1
        continue
      # Contiguous
      if (new_x, new_y) in block:
        continue

      # Borders other blocks on this side
      sum += 1

  return sum

def part1(input_text):
  grid = parse(input_text)
  block_sets = []
  visited = set()

  for y in range(len(grid)):
    for x in range(len(grid[y])):
      if (x, y) in visited:
        continue
      block = blocks(grid, x, y)
      block_sets.append(block)
      visited.update(block)

  sum = 0
  for block in block_sets:
    p = perimeter(grid, block)
    sum += p * len(block)

  return sum

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))