import itertools
import sys

def parse(input_text):
  out = []
  data = True
  data_idx = 0
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    for char in line:
      n = int(char)
      if data:
        for j in range(n):
          out.append(data_idx)
        data_idx += 1
        data = False
      else:
        for j in range(n):
          out.append(None)
        data = True

  return out

def sparse_parse(input_text):
  blocks = []
  frees = []
  data_idx = 0
  data = True
  pos = 0
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    for char in line:
      n = int(char)
      if data:
        blocks.append((data_idx, pos, n))
        data_idx += 1
        data = False
      else:
        frees.append((pos, n))
        data = True
      pos += n

  return (blocks, frees)

def sparse_to_arr(blocks):
  blocks.sort(key=lambda x: x[1])
  _, pos, size = blocks[-1]
  data = [None] * (pos + size)

  for block in blocks:
    n, pos, size = block
    for i in range(size):
      data[pos + i] = n

  return data

def repack(data):
  out = []
  j = len(data) - 1
  for i in range(len(data)):
    # TODO double and triple check off-by-one-errors here
    if i > j:
      break
    if data[i] == None:
      while data[j] == None:
        j -= 1
      if i > j:
        break
      out.append(data[j])
      j -= 1
    else:
      out.append(data[i])

  return out

def repack_intact(blocks, frees):
  for i in range(len(blocks) - 1, -1, -1):
    n, pos, size = blocks[i]
    for j in range(len(frees)):
      fpos, fsize = frees[j]
      # Break if the free block is after our block
      if fpos > pos:
        break
      if fsize >= size:
        blocks[i] = (n, fpos, size)
        frees[j] = (fpos + size, fsize - size)
        # A zero size free block should be fine
        # We don't need to create a new free block because we'll never pass that space
        break

  return (blocks, frees)


def checksum(data):
  sum = 0
  for i in range(len(data)):
    if data[i] == None:
      continue
    sum += data[i] * i

  return sum

def part1(input_text):
  parsed_data = parse(input_text)
  repacked_data = repack(parsed_data)
  return checksum(repacked_data)

def part2(input_text):
  b, f = sparse_parse(input_text)
  new_b, _ = repack_intact(b, f)
  repacked = sparse_to_arr(new_b)
  return checksum(repacked)

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))