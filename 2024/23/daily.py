def parse(input_text):
  graph = {}

  for line in input_text.strip().split('\n'):
    if not line:
      continue

    a, b = line.split('-')

    if a not in graph:
      graph[a] = set()
    if b not in graph:
      graph[b] = set()

    graph[a].add(b)
    graph[b].add(a)

  return graph

def find_triplets(graph):
  triplets = []

  for a in graph:
    for b in graph[a]:
      for c in graph[b]:
        if a in graph[c]:
          triplet = tuple(sorted([a, b, c]))
          if triplet not in triplets:
            triplets.append(triplet)

  return triplets

def part1(input_text):
  graph = parse(input_text)
  triplets = find_triplets(graph)
  counter = 0
  for a, b, c in triplets:
    if a[0] == 't' or b[0] == 't' or c[0] == 't':
      counter += 1
  return counter

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))