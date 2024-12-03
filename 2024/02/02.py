import sys

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(map(int, line.split())))
  return out

def safe(vals):
  increasing = True
  if vals[0] > vals[1]:
    increasing = False
  prev = vals[0]
  for i in range(len(vals)):
    if i == 0:
      continue
    if increasing:
      if vals[i] < prev:
        return False
    else:
      if vals[i] > prev:
        return False
    diff = abs(vals[i] - prev)
    if diff < 1 or diff > 3:
      return False
    prev = vals[i]
  return True

def part1(input_text):
  data = parse(input_text)
  # print(data)
  return sum(map(safe, data))

sample = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

print(part1(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part1(file.read()))