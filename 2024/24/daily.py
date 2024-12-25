import random

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
  wires = [wire]
  if wire in values:
    return values[wire], wires

  a, op, b = connections[wire]
  a_val, a_wires = power_up(a, connections, values)
  b_val, b_wires = power_up(b, connections, values)

  wires += a_wires + b_wires

  if op == 'AND':
    return a_val & b_val, wires
  elif op == 'OR':
    return a_val | b_val, wires
  elif op == 'XOR':
    return a_val ^ b_val, wires

  return 0, []

def generate_mermaid(file_path, touched_wires=None):
    inputs = set()
    outputs = set()
    operations = []

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            if ':' in line:
                continue
            if not line:
                continue  # Skip empty lines
            parts = line.split()
            left1, operator, left2, _, right = parts
            if left1.startswith(('x', 'y')):
                if not touched_wires or left1 in touched_wires:
                  inputs.add(left1)
            if left2.startswith(('x', 'y')):
                if not touched_wires or left2 in touched_wires:
                  inputs.add(left2)
            if right.startswith('z'):
                if not touched_wires or right in touched_wires:
                  outputs.add(right)
            if not touched_wires or right in touched_wires:
              operations.append((left1, operator, left2, right))

    input_nodes = "\n".join(f"    {node}" for node in sorted(inputs, key=lambda x: (x[-2:] + x[0])))
    output_nodes = "\n".join(f"    {node}" for node in sorted(outputs))

    init_operator_nodes = []
    operation_lines = []
    for left1, operator, left2, right in operations:
        if left1 > left2:
          left1, left2 = left2, left1
        operation_id = f"{operator}_{left1}_{left2}"
        if left1.startswith('x'):
           init_operator_nodes.append(operation_id)
        if operator == 'AND':
            operation_shape = '@{ shape: circ, label: AND }'
        elif operator == 'XOR':
            operation_shape = '@{ shape: hourglass }'
        elif operator == 'OR':
            operation_shape = '@{ shape: diamond, label: OR }'
        else:
            operation_shape = '@{ shape: rect }'  # For OR and other operators
        operation_lines.append(f"    {operation_id}{operation_shape} --> {right}")
        operation_lines.append(f"    {left1} --> {operation_id}")
        operation_lines.append(f"    {left2} --> {operation_id}")

    # breakpoint()
    operator_nodes_sorted = "\n".join(f"    {node}" for node in sorted( init_operator_nodes, key=lambda x: tuple(x.split('_')[::-1])))
    operation_nodes = "\n".join(operation_lines)
    mermaid_code = f"""
graph TD
    subgraph inputs
{input_nodes}
    end
    subgraph initial_op
{operator_nodes_sorted}
    end
    subgraph outputs
{output_nodes}
    end
{operation_nodes}
"""

    return mermaid_code.strip()

def survey_wires(connections, values):
  wire_map = {}
  for wire in connections:
    if wire.startswith('z'):
      zval, wires = power_up(wire, connections, values)
      wire_map[wire] = wires

  for wire in sorted(wire_map.keys()):
    inputs = set()
    input_count = {}
    expected_inputs = set()
    for i in range(int(wire[1:]) + 1):
      expected_inputs.add(f'x{i:02}')
      expected_inputs.add(f'y{i:02}')
    for w in wire_map[wire]:
      if w.startswith('x') or w.startswith('y'):
        inputs.add(w)
        if w not in input_count:
          input_count[w] = 0
        input_count[w] += 1
    # print(f"{wire} -> {sorted(inputs)}")
    missing_inputs = expected_inputs - inputs
    extra_inputs = inputs - expected_inputs
    # if missing_inputs:
    #   print(f"{wire} -> {sorted(inputs)} missing {sorted(missing_inputs)}")
    # if extra_inputs:
    #   print(f"{wire} -> {sorted(inputs)} extra {sorted(extra_inputs)}")

    # if wire == 'z34':
    #   print(f"{wire} -> {sorted(input_count.items())}")

    if wire == 'z34':
      file_path = __file__.rsplit('/', 1)[0] + "/input.txt"
      out = generate_mermaid(file_path, touched_wires=wire_map[wire])
      print(out)
  # file_path = __file__.rsplit('/', 1)[0] + "/input.txt"
  # out = generate_mermaid(file_path)
  # print(out)

def testing_adder(connections):
  for bits in range(44):
    st = 2**bits
    en = 2**(bits+1)
    for i in range(8):
      # Generate a random number between 2**bita and 2**(bits+1)
      num = random.randint(st, en)
      x = random.randint(0, num)
      y = num - x
      vals = {}
      for j in range(45):
        vals[f'x{j:02}'] = (x >> j) & 1
        vals[f'y{j:02}'] = (y >> j) & 1
      zvals = 0
      for wire in connections:
        if wire.startswith('z'):
          zval, wires = power_up(wire, connections, vals)
          bit_pos = int(wire[1:])
          zvals |= zval << bit_pos
      if zvals != num:
        print(f"num: {num} zvals: {zvals} bits: {bits} iter: {i}")
        return False
      
  return True


def part1(input_text):
  # power up all zvals
  connections, values = parse(input_text)
  zvals = 0
  for wire in connections:
    if wire.startswith('z'):
      zval, wires = power_up(wire, connections, values)
      bit_pos = int(wire[1:])
      zvals |= zval << bit_pos

  return zvals

def part2(input_text):
  connections, values = parse(input_text)
  # test a bunch of random numbers
  testing_adder(connections)
  survey_wires(connections, values)
  return 0

if __name__ == "__main__":
  # with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
  #   print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    # print(part2(file.read()))
    part2(file.read())