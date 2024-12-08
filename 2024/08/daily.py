import itertools
import sys

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(line))
  return out

def antinodes(data):
  nodes = set()
  ants = {}

  # Populate antennas
  for y in range(len(data)):
    for x in range(len(data[y])):
      if data[y][x] != '.':
        char = data[y][x]
        ants[char] = ants.get(char, set())
        ants[char].add((x, y))

  for ant_id, locs in ants.items():
    for loc_a, loc_b in itertools.combinations(locs, 2):
      if loc_a != loc_b:
        x_a, y_a = loc_a
        x_b, y_b = loc_b

        x_d = x_a - x_b
        y_d = y_a - y_b

        x_n1 = x_a + x_d
        y_n1 = y_a + y_d
        # print(f"Ant: {ant_id} A: {loc_a} B: {loc_b} D: ({x_d}, {y_d})")
        if x_n1 >= 0 and x_n1 < len(data[0]) and y_n1 >= 0 and y_n1 < len(data):
          # print(f"\t{x_n1, y_n1}") 
          nodes.add((x_n1, y_n1))

        x_n2 = x_b - x_d
        y_n2 = y_b - y_d
        if x_n2 >= 0 and x_n2 < len(data[0]) and y_n2 >= 0 and y_n2 < len(data):
          # print(f"\t{x_n2, y_n2}") 
          nodes.add((x_n2, y_n2))

        # print(f"Nodes: {nodes}")

  return nodes


def repeating_antinodes(data):
  nodes = set()
  ants = {}

  # Populate antennas
  for y in range(len(data)):
    for x in range(len(data[y])):
      if data[y][x] != '.':
        char = data[y][x]
        ants[char] = ants.get(char, set())
        ants[char].add((x, y))

  for ant_id, locs in ants.items():
    for loc_a, loc_b in itertools.combinations(locs, 2):
      if loc_a != loc_b:
        x_a, y_a = loc_a
        x_b, y_b = loc_b

        x_d = x_a - x_b
        y_d = y_a - y_b

        x_n1 = x_a
        y_n1 = y_a
        while True:
          if x_n1 >= 0 and x_n1 < len(data[0]) and y_n1 >= 0 and y_n1 < len(data):
            nodes.add((x_n1, y_n1))
            x_n1 = x_n1 + x_d
            y_n1 = y_n1 + y_d
          else:
            break

        x_n2 = x_b
        y_n2 = y_b
        while True:
          if x_n2 >= 0 and x_n2 < len(data[0]) and y_n2 >= 0 and y_n2 < len(data):
            nodes.add((x_n2, y_n2))
            x_n2 = x_n2 - x_d
            y_n2 = y_n2 - y_d
          else:
            break

  return nodes

def part1(input_text):
  data = parse(input_text)
  return len(antinodes(data))

def part2(input_text):
  data = parse(input_text)
  return len(repeating_antinodes(data))

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))