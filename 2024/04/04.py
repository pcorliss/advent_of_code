import sys

sample = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(line))
  return out

def match_string(chars, grid, x, y, x_dir, y_dir):
  new_x = x + x_dir
  new_y = y + y_dir
  if new_x < 0 or new_x >= len(grid[0]) or new_y < 0 or new_y >= len(grid):
    return False

  if chars[0] != grid[new_y][new_x]:
    return False
  
  if len(chars) == 1:
    return True
  
  return match_string(chars[1:], grid, new_x, new_y, x_dir, y_dir)

def part1(input_text):
  data = parse(input_text)

  sum = 0
  dirs = [
    (1, 0), # EAST
    (-1, 0), # WEST
    (0, 1), # SOUTH
    (0, -1), # NORTH
    (1, 1), # SE
    (-1, 1), # SW
    (1, -1), # NE
    (-1, -1), # NW
  ]
  chars = list("MAS")
  for y in range(len(data)):
    for x in range(len(data[y])):
      if data[y][x] != "X":
        continue

      for dir in dirs:
        if match_string(chars, data, x, y, dir[0], dir[1]):
          sum += 1

  return sum

def part2(input_text):
  data = parse(input_text)

  sum = 0
  match_sets = [
    {
      (-1, -1): 'M',
      (-1, 1): 'M',
      (1, -1): 'S',
      (1, 1): 'S',
    },
    {
      (-1, -1): 'M',
      (-1, 1): 'S',
      (1, -1): 'M',
      (1, 1): 'S',
    },
    {
      (-1, -1): 'S',
      (-1, 1): 'S',
      (1, -1): 'M',
      (1, 1): 'M',
    },
    {
      (-1, -1): 'S',
      (-1, 1): 'M',
      (1, -1): 'S',
      (1, 1): 'M',
    },
  ]

  for y in range(1, len(data) - 1):
    for x in range(1, len(data[y]) - 1):
      if data[y][x] != "A":
        continue

      for match_set in match_sets:
        if all(
          data[y + coord[1]][x + coord[0]] == char
          for coord, char in match_set.items()
        ):
          sum += 1
          break

  return sum


print(part1(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part1(file.read()))

print(part2(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part2(file.read()))