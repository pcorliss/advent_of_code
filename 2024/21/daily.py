def parse(input_text):
  codes = []

  for line in input_text.strip().split("\n"):
    if not line:
      continue

    codes.append(list(line))

  return codes

# +---+---+---+       +---+---+
# | 7 | 8 | 9 |       | ^ | A |
# +---+---+---+   +---+---+---+
# | 4 | 5 | 6 |   | < | v | > |
# +---+---+---+   +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+  

digit_pos = {
  'A': (2, 3),
  '0': (1, 3),
  '1': (0, 2),
  '2': (1, 2),
  '3': (2, 2),
  '4': (0, 1),
  '5': (1, 1),
  '6': (2, 1),
  '7': (0, 0),
  '8': (1, 0),
  '9': (2, 0),
  'B': (0, 3),
}

dpad_pos = {
  '^': (1, 0),
  'A': (2, 0),
  '<': (0, 1),
  'v': (1, 1),
  '>': (2, 1),
  'B': (0, 0),
}

START_POS = 'A'
DIGIT = 0
DPAD = 1

# optimal_dpad = {
#     'A': {"A": [""], "^": ["<"], ">": ["v"], "v": ["<v", "v<"], "<": ["v<<"]},
#     '^': {"^": [""], "A": [">"], "v": ["v"], "<": ["v<"], ">": ["v>"]},
#     'v': {"v": [""], "A": ["^>", ">^"], "^": ["^"], "<": ["<"], ">": [">"]},
#     '<': {"<": [""], "A": [">>^"], "^": [">^"], "v": [">"], ">": [">>"]},
#     '>': {">": [""], "A": ["^"], "^": ["^<", "<^"], "v": ["<"], "<": ["<<"]},
# }

# One directional keypad that you are using.
# Two directional keypads that robots are using.
# One numeric keypad (on a door) that a robot is using.
def code_directions(code):
  pos = [(DIGIT, digit_pos[START_POS]), (DPAD, dpad_pos['A']), (DPAD, dpad_pos['A'])]
  commands = [[], [], [], [], [], []]
  for digit in code:
    commands[0].append(digit)
    next_command = [digit]
    sub_commands = []
    for pos_idx in range(len(pos)):
      pad_type, pad_pos = pos[pos_idx]
      for command in next_command:
        print(f"{"\t"*(pos_idx)}Idx: {pos_idx} PadType: {pad_type} Command: {command}")
        target_pos = digit_pos[command] if pad_type == DIGIT else dpad_pos[command]
        dx = target_pos[0] - pad_pos[0]
        dy = target_pos[1] - pad_pos[1]
        new_commands = []
        # Account for the blank space we're trying to avoid
        blank_pos = digit_pos['B'] if pad_type == DIGIT else dpad_pos['B']
        x_cmds = list('>' * dx if dx > 0 else '<' * -dx) if dx != 0 else []
        y_cmds = list('v' * dy if dy > 0 else '^' * -dy) if dy != 0 else []
        if dx + pad_pos[0] == blank_pos[0] and pad_pos[1] == blank_pos[1]:
          new_commands += y_cmds + x_cmds
        else:
          new_commands += x_cmds + y_cmds
        new_commands.append('A')
        pos[pos_idx] = (pad_type, target_pos)
        pad_pos = target_pos
        print(f"{"\t"*(pos_idx+1)}New Commands: {new_commands}")
        sub_commands += new_commands

      commands[pos_idx + 1] += sub_commands
      next_command = sub_commands 
      sub_commands = []



  # E: <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A
  # E: v<<A>>^A<A>AvA<^AA>A<vAAA>^A
  # E: <A^A>^^AvvvA
  # E: 029A

  # Line 3: 456A
  # v<<A^>>AAv<A<A^>>AAvAA^<A>Av<A^>A<A>Av<A^>A<A>Av<<A>A^>AAvA^<A>A [human]
  #    <   AA  v <   AA >>  ^ A  v  A ^ A  v  A ^ A   < v  AA >  ^ A [robot 3]
  #        ^^        <<       A     >   A     >   A        vv      A [robot 2]
  #                           4         5         6                A [keypad robot]

  # Commands: 456A
  # Commands: <<^^A>A>AvvA
  # Me        <AAv<AA>>^AvA^AvA^A<vAA>^A
  # Commands: <<vAA>^AA>AvA^AvA^A<vAA>^A
  # Commands: 60 <<vAA>A>^AAvA<^A>AAvA^A<vA>^A<A>A<vA>^A<A>A<<vA>A>^AAvA<^A>A

  # print(f"Commands: {commands}")
  print(f"Commands: {"".join(commands[0])}")
  print(f"Commands: {"".join(commands[1])}")
  print(f"Commands: {"".join(commands[2])}")
  print(f"Commands: {len(commands[3])} {"".join(commands[3])}")

  return commands[3]

def complexity(code, length):
  return int(''.join(code[0:3])) * length

def part1(input_text):
  codes = parse(input_text)
  total_complexity = 0
  for code in codes:
    directions = code_directions(code)
    total_complexity += complexity(code, len(directions))
  return total_complexity

# 212128 - too high

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))