import sys

sample = """
3   4
4   3
2   5
1   3
3   9
3   3
"""

input_text = ""
if len(sys.argv) > 1:
    print(f"Sysv Args: {sys.argv}")
    input = open("input.txt", "r+")
    input_text = input.read()
    input.close()
else:
    input_text = sample

col1 = []
col2 = []
count2 = {}

for line in input_text.split("\n"):
    if len(line) == 0:
        continue
    # print(f"Line: {line}")
    a, b = line.split()
    # print(f"A: {a} B: {b}")
    a = int(a)
    b = int(b)
    col1.append(a)
    col2.append(b)
    count2[b] = count2.get(b, 0) + 1

col1.sort()
col2.sort()

sum = 0
sim = 0
for a, b in zip(col1, col2):
    sum += abs(b - a)
    sim += count2.get(a, 0) * a

print(f"Sum: {sum}")
print(f"Sim: {sim}")

