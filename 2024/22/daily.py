def parse(input_text):
  codes = []

  for line in input_text.strip().split("\n"):
    if not line:
      continue

    codes.append(int(line))

  return codes


def gen_code(secret_number, generation):
  def mix(s, code):
    return s ^ code

  def prune(code):
    return code & 16777215 # 2**24 - 1

  code = secret_number

  for i in range(generation):
    to_mix = code << 6 # multiply by 64
    code = mix(code, to_mix)
    code = prune(code)
    to_mix = code >> 5 # divide by 32
    code = mix(code, to_mix)
    code = prune(code)
    to_mix = code << 11 # multiply by 2048
    code = mix(code, to_mix)
    code = prune(code)

  return code

def part1(input_text):
  codes = parse(input_text)
  sum = 0
  for code in codes:
    sum += gen_code(code, 2000)
  return sum

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))