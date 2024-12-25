import itertools
import sys

def parse(input_text):
  locks = []
  keys = []

  working_lock_key = []
  for line in input_text.strip().split('\n'):
    if not line:
      if working_lock_key:
        if working_lock_key[0][0] == '.':
          keys.append(working_lock_key)
        else:
          locks.append(working_lock_key)
        working_lock_key = []
      continue

    working_lock_key.append(list(line))

  if working_lock_key[0][0] == '.':
    keys.append(working_lock_key)
  else:
    locks.append(working_lock_key)
  return locks, keys

def pin_heights(lock_or_key):
  print(lock_or_key)
  lock_range = range(1, len(lock_or_key))
  key = False

  # It's a key, read backwards and skip the first element
  if lock_or_key[0][0] == '.':
      key = True
      lock_range = range(len(lock_or_key) - 1, 0, -1)

  pin_heights = [0] * len(lock_or_key[0])
  for i in lock_range:
    print(f"Row: {i} - {lock_or_key[i]}")
    for j in range(len(lock_or_key[i])):
      if lock_or_key[i][j] == '#':
        if key:
          pin_heights[j] = len(lock_or_key) - i - 1
        else:
          pin_heights[j] = i

  return pin_heights

def overlap(lock, key):
  # zip lock and key together
  for l, k in zip(lock, key):
    if l + k > 5:
      return True
    
  return False

def part1(input_text):
  locks, keys = parse(input_text)

  lock_pins = []
  for l in locks:
    lock_pins.append(pin_heights(l))

  key_pins = []
  for k in keys:
    key_pins.append(pin_heights(k))

  counter = 0
  for l, k in itertools.product(lock_pins, key_pins):
    if not overlap(l, k):
      counter += 1

  return counter

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))