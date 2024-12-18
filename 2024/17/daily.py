import queue

def parse(input_text):
  registers = {
    'A': 0,
    'B': 0,
    'C': 0
  }

  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue

    if 'Register' in line:
      register, value = line.split(': ')
      _, register_key = register.split(' ')

      registers[register_key] = int(value)

    if 'Program' in line:
      _, program_str = line.split(': ')
      program = [int(x) for x in program_str.split(',')]
      return registers, program

  return registers, []

def get_combo(combo, registers):
  if combo <= 3:
    return combo
  if combo == 4:
    return registers['A']
  if combo == 5:
    return registers['B']
  if combo == 6:
    return registers['C']

  return -1

def run_program(registers, program):
  ip = 0
  output = []
  while ip < len(program):
    op = program[ip]
    ip += 1
    # The adv instruction (opcode 0) performs division.
    # The numerator is the value in the A register.
    # The denominator is found by raising 2 to the power of the instruction's combo operand.
    # The result of the division operation is truncated to an integer and then written to the A register.
    # The bdv instruction (opcode 6) works exactly like the adv instruction
    # except that the result is stored in the B register.
    # The cdv instruction (opcode 7) works exactly like the adv instruction
    # except that the result is stored in the C register.
    if op == 0 or op == 6 or op == 7:
      register_key = 'A'
      if op == 6:
        register_key = 'B'
      elif op == 7:
        register_key = 'C'
      registers[register_key] = registers['A'] // (2 ** get_combo(program[ip], registers))
      ip += 1
    # The bxl instruction (opcode 1) calculates the bitwise XOR of register B
    # and the instruction's literal operand, then stores the result in register B.
    elif op == 1:
      registers['B'] ^= program[ip]
      ip += 1
    # The bst instruction (opcode 2) calculates the value of its combo operand modulo 8
    elif op == 2:
      # TODO this would be faster if we just grabbed the 3 lowest bits instead
      registers['B'] = get_combo(program[ip], registers) % 8
      ip += 1
    # The jnz instruction (opcode 3) does nothing if the A register is 0.
    # However, if the A register is not zero, it jumps by setting the instruction pointer
    # to the value of its literal operand;
    # if this instruction jumps,
    # the instruction pointer is not increased by 2 after this instruction.
    elif op == 3:
      if registers['A'] == 0:
        ip += 1
      else:
        ip = program[ip]
    # The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C,
    # then stores the result in register B
    elif op == 4:
      registers['B'] ^= registers['C']
      ip += 1
    # The out instruction (opcode 5) calculates the value of its combo operand modulo 8,
    # then outputs that value.
    elif op == 5:
      output.append(get_combo(program[ip], registers) % 8)
      ip += 1
      
  return registers, output

def part1(input_text):
  registers, program = parse(input_text)
  _, output = run_program(registers, program)
  return output

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    out = part1(file.read())
    print(','.join(list(map(str, out))))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))