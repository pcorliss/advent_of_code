import sys

sample = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

def middle_number(pages):
  return pages[len(pages) // 2]

def sorted_pages(pages, before_map, after_map):
  for i in range(len(pages) - 1):
    if pages[i] not in before_map:
      continue
    for j in range(i + 1, len(pages)):
      if pages[j] in before_map[pages[i]]:
        return False

  return True

def parse(input_text):
  page_lists = []
  before_map = {}
  after_map = {}
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue
    elif '|' in line:
      a, b = [int(n) for n in line.split('|')]
      # 75|47
      # before_map[47] == [75]
      # after_map[75] == [47]
      before_map[b] = before_map.get(b, set())
      before_map[b].add(a)
      after_map[a] = after_map.get(a, set())
      after_map[a].add(b)
    elif ',' in line:
      page_list = [int(n) for n in line.split(',')]
      page_lists.append(page_list)

  return [page_lists, before_map, after_map]

def part1(input_text):
  page_lists, before_map, after_map = parse(input_text)

  sum = 0
  for page_list in page_lists:
    if sorted_pages(page_list, before_map, after_map):
      sum += middle_number(page_list)

  return sum

print(part1(sample))
if len(sys.argv) >= 2:
  with open(sys.argv[1], 'r') as file:
    print(part1(file.read()))

# print(part2(sample))
# if len(sys.argv) >= 2:
#   with open(sys.argv[1], 'r') as file:
#     print(part2(file.read()))