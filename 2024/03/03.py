
import re
import sys

def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    out.append(line)
  return out

def part1(input_text):
  data = parse(input_text)
  sum = 0
  for line in data:
    matches = re.findall(r"mul\((\d+),(\d+)\)", line)
    print(f"Line: {line} matches: {matches}")
    for match in matches:
      mul = int(match[0]) * int(match[1])
      sum += mul

  return sum



sample = """
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"""

print(part1(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part1(file.read()))

# print(part2(sample))
# if len(sys.argv) >= 2:
#   with open(sys.argv[1], 'r') as file:
#     print(part2(file.read()))