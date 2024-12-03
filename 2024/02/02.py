import sys

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(list(map(int, line.split())))
  return out

def safe_vals(vals):
  inc = 0
  dec = 0
  prev = None
  for i in range(len(vals)):
    if i == 0:
      prev = vals[i]
      continue

    if vals[i] > prev:
      inc += 1
    elif vals[i] < prev:
      dec += 1
    else:
      return False
    
    if min(inc, dec) > 0:
      return False
    
    diff = abs(vals[i] - prev)
    if diff < 1 or diff > 3:
      return False

    prev = vals[i]

  return True

def safe(vals):
  if safe_vals(vals):
    return True

  for i in range(len(vals)):
    # remove i from the list
    new_vals = vals[:i] + vals[i+1:]
    if safe_vals(new_vals):
      return True
    
  return False

def part1(input_text):
  data = parse(input_text)
  # print(data)
  return sum(map(safe_vals, data))

def part2(input_text):
  data = parse(input_text)
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

print(part2(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part2(file.read()))

# 450 is not right
# 442 That's not the right answer; your answer is too low.