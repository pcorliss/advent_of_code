from pygtrie import CharTrie, StringTrie, PrefixSet

def parse(input_text):
  tokens = []
  words = []
  t = CharTrie()

  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue

    if not tokens:
      tokens = line.split(', ')
      for token in tokens:
        t[token] = True
      continue

    words.append(line)

  return tokens, words, t

def string_contains(str, trie):
  for prefix, _ in trie.prefixes(str):
    # print(f"Prefix: {prefix} in {str}")
    if prefix == str:
      return True
    
    if string_contains(str[len(prefix):], trie):
      return True
    
  return False

def part1(input_text):
  tokens, words, trie = parse(input_text)
  return sum(string_contains(word, trie) for word in words)

def part2(input_text):
  return 0

if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read()))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read()))