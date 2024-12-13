def parse(input_text):
  machines = []
  next_machine = {}
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      if next_machine:
        machines.append(next_machine)
        next_machine = {}
      continue
    
    if 'Button A' in line:
      x, y = line.split(': ')[1].split(', ')
      _, x_d = x.split('+')
      _, y_d = y.split('+')
      next_machine['A'] = (int(x_d), int(y_d))
    elif 'Button B' in line:
      x, y = line.split(': ')[1].split(', ')
      _, x_d = x.split('+')
      _, y_d = y.split('+')
      next_machine['B'] = (int(x_d), int(y_d))
    elif 'Prize' in line:
      x, y = line.split(': ')[1].split(', ')
      _, x_d = x.split('=')
      _, y_d = y.split('=')
      next_machine['prize'] = (int(x_d), int(y_d))
  if next_machine:
    machines.append(next_machine)

  return machines

def solver(machine):
  a_x, a_y = machine['A']
  b_x, b_y = machine['B']
  p_x, p_y = machine['prize']

  # We're solving for this system of equations
  # a_x * a + b_x * b = p_x
  # a_y * a + b_y * b = p_y

  determinant = a_x * b_y - a_y * b_x
  a = (p_x * b_y - p_y * b_x) / determinant
  b = (p_y * a_x - p_x * a_y) / determinant

  if a.is_integer() and b.is_integer():
    return [a,b]

  return None

def cost(tokens):
  a, b = tokens
  return int(3 * a + 1 * b)

def part1(input_text):
  machines = parse(input_text)
  sum = 0
  for machine in machines:
    tokens = solver(machine)
    if tokens:
      sum += cost(tokens)
  return sum

def part2(input_text):
  machines = parse(input_text)
  sum = 0
  for machine in machines:
    prize = machine['prize']
    prize = (prize[0] + 10000000000000, prize[1] + 10000000000000)
    machine['prize'] = prize
    tokens = solver(machine)
    if tokens:
      sum += cost(tokens)
  return sum

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))