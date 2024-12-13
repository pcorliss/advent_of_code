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

def corners(block):
  #  X#X
  #  ###
  #  X#X
  inner_corners = [
    ((-1,0), (0,-1), (-1,-1)),
    ((1,0), (0,-1), (1,-1)),
    ((1,0), (0,1), (1,1)),
    ((-1,0), (0,1), (-1,1)),
  ]

  #  X_X
  #  _#_
  #  X_X
  outer_corners = [
    ((-1,0), (0,-1)),
    ((1,0), (0,-1)),
    ((1,0), (0,1)),
    ((-1,0), (0,1)),
  ]

  sum = 0
  for x, y in block:
    for (xa, ya), (xb, yb), (xc, yc) in inner_corners:
      if (x+xa,y+ya) in block and (x+xb,y+yb) in block and not (x+xc,y+yc) in block:
        sum += 1
    for (xa, ya), (xb, yb) in outer_corners:
      if (x+xa,y+ya) not in block and (x+xb,y+yb) not in block:
        sum += 1

  return sum


def sides(grid, block):
  sum = 0

  min_x = min([x for x, _ in block])
  max_x = max([x for x, _ in block])
  min_y = min([y for _, y in block])
  max_y = max([y for _, y in block])

  # read from left to right
  # if there's a block and not a block above then there's a side
  # side_check on, if side_check off, add one to side
  # if not a block then side_check off
  # new line reset side_check
  for y in range(min_y, max_y + 1):
    up_side_check = False
    down_side_check = False
    for x in range(min_x, max_x + 1):
      if (x, y) in block and (x, y - 1) not in block:
          if not up_side_check:
            up_side_check = True
            sum += 1
      else:
        up_side_check = False

      if (x, y) in block and (x, y + 1) not in block:
          if not down_side_check:
            down_side_check = True
            sum += 1
      else:
        down_side_check = False

  # Do the same but left and right
  for x in range(min_x, max_x + 1):
    right_side_check = False
    left_side_check = False
    for y in range(min_y, max_y + 1):
      if (x, y) in block and (x + 1, y) not in block:
          if not right_side_check:
            right_side_check = True
            sum += 1
      else:
        right_side_check = False

      if (x, y) in block and (x - 1, y) not in block:
          if not left_side_check:
            left_side_check = True
            sum += 1
      else:
        left_side_check = False

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
    s = corners(block)
    sum += s * len(block)

  return sum

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))