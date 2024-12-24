def parse(input_text):
  graph = {}

  for line in input_text.strip().split('\n'):
    if not line:
      continue

    a, b = line.split('-')

    if a not in graph:
      graph[a] = set([a])
    if b not in graph:
      graph[b] = set([b])

    graph[a].add(b)
    graph[b].add(a)

  return graph

triplets = []
def find_triplets(graph):
  if triplets:
    return triplets

  for a in graph:
    for b in graph[a]:
      if a == b:
        continue
      for c in graph[b]:
        if a == c or b == c:
          continue
        if a in graph[c]:
          triplet = tuple(sorted([a, b, c]))
          if triplet not in triplets:
            triplets.append(triplet)

  return triplets

def valid_cluster(graph, inter):
  for node in inter:
    if not graph[node].issuperset(inter):
      return False
    
  return True

def prune_intersection(graph, triplet, test_int):
  candidates = {triplet: test_int}

  best_tuple = ()
  best_int = set()

  while candidates:
    nodes, inter = candidates.popitem()
    # print(f"Nodes: {nodes} - {inter}")
    for n in inter:
      if n in nodes:
        continue

      new_int = inter.intersection(graph[n])
      # print(f"\tNew: {new_int}")


      if len(new_int) > len(best_int):
        # print(f"\t\tNew best: {nodes} + {n} - {new_int}")
        if valid_cluster(graph, new_int):
          # print(f"\t\t\tValid")
          if len(nodes) + 1 == len(new_int):
            # print(f"\t\t\t\tLengths Equal")
            best_tuple = nodes + (n,)
            best_int = new_int


      candidates[nodes + (n,)] = new_int

  print(f"Best: {best_tuple} - {best_int}") 
  return tuple(sorted(best_int))

def largest_group(graph, triplets):
  largest = None

  for a, b, c in triplets:
    intersection = graph[a].intersection(graph[b], graph[c])
    if largest is None or len(intersection) > len(largest):
      pruned = prune_intersection(graph, (a, b, c), intersection)
      if largest is None or len(pruned) > len(largest):
        largest = set(pruned)

  print(f"Largest: {largest}")
  print(f"Valid?: {valid_cluster(graph, largest)}")
  return largest

def part1(input_text):
  graph = parse(input_text)
  triplets = find_triplets(graph)
  counter = 0
  for a, b, c in triplets:
    if a[0] == 't' or b[0] == 't' or c[0] == 't':
      counter += 1
  return counter

def part2(input_text):
  graph = parse(input_text)
  triplets = find_triplets(graph)
  largest = largest_group(graph, triplets)
  return ",".join(sorted(largest))

# Not right answer
# ab,cg,es,fl,gf,il,ir,kg,mq,po,te,ud,wv

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))