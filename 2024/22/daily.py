def parse(input_text):
  codes = []

  for line in input_text.strip().split("\n"):
    if not line:
      continue

    codes.append(int(line))

  return codes

sum_sequence = {}
def gen_code(secret_number, generation):
  def mix(s, code):
    return s ^ code

  def prune(code):
    return code & 16777215 # 2**24 - 1

  code = secret_number
  last_digit = code % 10
  last_diff = [None, None, None, None]

  gen_sequence = {}
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

    new_last_digit = code % 10
    diff = new_last_digit - last_digit
    last_diff = last_diff[1:]
    last_diff.append(diff)

    # We want the first sequence for this generation
    sequence_key = tuple(last_diff)
    if i > 2 and sequence_key not in gen_sequence:
      # if sequence_key == (-2,1,-1,3):
      #   print(f"{secret_number} - Sequence: {sequence_key} - G:{i} - C: {code} NLD: {new_last_digit} - LastDigit: {last_digit}")
      gen_sequence[tuple(last_diff)] = new_last_digit

    last_digit = new_last_digit

  for k, v in gen_sequence.items():
    if k not in sum_sequence:
      sum_sequence[k] = 0
    # if k == (-2,1,-1,3):
    #   print(f"\tAdding {v} to {sum_sequence[k]}")
    sum_sequence[k] += v

  return code

def part1(input_text):
  codes = parse(input_text)
  sum = 0
  for code in codes:
    sum += gen_code(code, 2000)
  return sum

def part2(input_text):
  global sum_sequence
  sum_sequence = {}
  codes = parse(input_text)
  for code in codes:
    gen_code(code, 2000)

  max_v = 0
  max_s = None
  print(f"Sum Sequence: {sum_sequence[(-2,1,-1,3)]}")
  for k, v in sum_sequence.items():
    if v > max_v:
      max_v = v
      max_s = k

  return max_s, max_v

# 3, 0, -5, -3 - not the right answer

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))