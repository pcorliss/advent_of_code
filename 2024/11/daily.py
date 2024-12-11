import itertools
import sys

def parse(input_text):
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    return list(map(int, line.split(' ')))

def blink(stones):
  out = []
  for s in stones:
    # If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
    if s == 0:
      out.append(1)
      continue
    # If the stone is engraved with a number that has an even number of digits,
    # it is replaced by two stones.
    # The left half of the digits are engraved on the new left stone,
    # and the right half of the digits are engraved on the new right stone
    # (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
    s_str = str(s)
    l = len(s_str)
    if l % 2 == 0:
      out.append(int(s_str[:l // 2]))
      out.append(int(s_str[l // 2:]))
      continue

    # If none of the other rules apply, the stone is replaced by a
    # new stone; the old stone's number multiplied by 2024
    # is engraved on the new stone.  
    out.append(s * 2024)

  return out

def part1(input_text):
  stones = parse(input_text)
  for _ in range(25):
    stones = blink(stones)
  return len(stones)

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))