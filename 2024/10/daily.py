import itertools
import sys

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(map(int, line)))

  return out

CARDINALS = [(0, 1), (0, -1), (1, 0), (-1, 0)]
PEAKS_CACHE = {}
PATH_CACHE = {}

def recurse_path_find(grid, x, y):
  if (x, y) in PEAKS_CACHE and (x, y) in PATH_CACHE:
    return (PEAKS_CACHE[(x, y)], PATH_CACHE[(x, y)])

  height = grid[y][x]
  if height == 9:
    return (set([(x, y)]), 1)

  peaks = set()
  paths = 0
  for dx, dy in CARDINALS:
    new_x = x + dx
    new_y = y + dy
    if new_x < 0 or new_x >= len(grid[0]) or new_y < 0 or new_y >= len(grid):
      continue
    if grid[new_y][new_x] != height + 1:
      continue
    new_peaks, paths_count = recurse_path_find(grid, new_x, new_y)
    peaks.update(new_peaks)
    paths += paths_count

  PEAKS_CACHE[(x, y)] = peaks
  PATH_CACHE[(x, y)] = paths
  # print(f"{x, y}: {len(peaks)} {list(peaks)}")
  return (peaks, paths)

def trail_heads(grid):
  trail_heads = []
  for y in range(len(grid)):
    for x in range(len(grid[0])):
      if grid[y][x] == 0:
        trail_heads.append((x, y))

  return trail_heads

def path_find(grid):
  peak_score = []
  for x, y in trail_heads(grid):
    peaks, _ = recurse_path_find(grid, x, y)
    peak_score.append(len(peaks))

  return peak_score

def path_score(grid):
  path_scores = []
  for x, y in trail_heads(grid):
    _, path_score = recurse_path_find(grid, x, y)
    path_scores.append(path_score)

  return path_scores


def part1(input_text):
  grid = parse(input_text)
  path_scores = path_find(grid)
  return sum(path_scores)

def part2(input_text):
  grid = parse(input_text)
  path_scores = path_score(grid)
  return sum(path_scores)

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))