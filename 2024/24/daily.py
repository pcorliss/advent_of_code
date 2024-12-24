def parse(input_text):
  connections = {}
  values = {}

  connections_capture = False
  for line in input_text.strip().split('\n'):
    if not line:
      if values:
        connections_capture = True
      continue

    if connections_capture:
      inputs, output = line.split(' -> ')
      connections[output] = tuple(inputs.split(' '))
      # print(f"connections: {output} {connections[output]}")
    else:
      key, value = line.split(': ')
      values[key] = int(value)

  return connections, values

def power_up(wire, connections, values):
  if wire in values:
    return values[wire]

  a, op, b = connections[wire]
  a_val = power_up(a, connections, values)
  b_val = power_up(b, connections, values)

  if op == 'AND':
    return a_val & b_val
  elif op == 'OR':
    return a_val | b_val
  elif op == 'XOR':
    return a_val ^ b_val

  return 0

def part1(input_text):
  # power up all zvals
  connections, values = parse(input_text)
  zvals = 0
  for wire in connections:
    if wire.startswith('z'):
      zval = power_up(wire, connections, values)
      bit_pos = int(wire[1:])
      zvals |= zval << bit_pos

  return zvals

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))