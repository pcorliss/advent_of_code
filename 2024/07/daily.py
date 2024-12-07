import sys
import itertools

def parse(input_text):
  out = {}
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    goal, n = line.split(': ')
    nums = n.split(' ')
    out[int(goal)] = list(map(int, nums))
  return out

def add_symbols(goal, nums, symbols):
  for symbols in itertools.product(symbols, repeat=len(nums) - 1):
    equation = [nums[0]]
    sum = nums[0]
    for i in range(1, len(nums)):
      equation.append(symbols[i - 1])
      equation.append(nums[i])
      if symbols[i - 1] == '*':
        sum *= nums[i]
      elif symbols[i - 1] == '+':
        sum += nums[i]
      elif symbols[i - 1] == '||':
        sum = int(f"{sum}{nums[i]}")
      else:
        raise f"Unknown symbol {equation}"

    if goal == sum:
      return equation
    
  return None

def part1(input_text):
  data = parse(input_text)
  sum = 0
  for goal, nums in data.items():
    equation = add_symbols(goal, nums, ['*', '+'])
    if equation:
      sum += goal
  return sum

def part2(input_text):
  data = parse(input_text)
  sum = 0
  for goal, nums in data.items():
    equation = add_symbols(goal, nums, ['*', '+', '||'])
    if equation:
      sum += goal
  return sum

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))
