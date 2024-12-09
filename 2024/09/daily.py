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

def checksum(data):
  sum = 0
  for i in range(len(data)):
    sum += data[i] * i

  return sum

def part1(input_text):
  parsed_data = parse(input_text)
  repacked_data = repack(parsed_data)
  return checksum(repacked_data)

def part2(input_text):
  data = parse(input_text)
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))