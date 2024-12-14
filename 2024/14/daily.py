def parse(input_text):
  out = []
  for line in input_text.strip().split('\n'):
    if len(line) == 0:
      continue

    pos_str, vel_str = line.split(' ')
    _, pos_xy_str = pos_str.split('=')
    _, vel_xy_str = vel_str.split('=')

    pos_xy = list(map(int, pos_xy_str.split(',')))
    vel_xy = list(map(int, vel_xy_str.split(',')))

    out.append((pos_xy, vel_xy))
    
  return out

def tick(robots, dims, ticks=1):
  new_robots = []
  for pos, vel in robots:
    new_pos = [(pos[0] + vel[0] * ticks) % dims[0], (pos[1] + vel[1] * ticks) % dims[1]]
    new_robots.append((new_pos, vel))
  return new_robots

def render_grid(robots, dims, hide_mid=False):
  x_mid = dims[0] // 2
  y_mid = dims[1] // 2 
  print(f"Hid: {hide_mid} X: {x_mid} Y: {y_mid}")
  robot_pos = list(map(lambda x: x[0], robots))
  for y in range(dims[1]):
    if hide_mid and y == y_mid:
      print(' ' * dims[0])
      continue
    for x in range(dims[0]):
      if hide_mid and x == x_mid:
        print(' ', end='')
        continue
      if [x,y] in robot_pos:
        count = robot_pos.count([x,y])
        print(count, end='')
      else:
        print('.', end='')
    print()

def count_quads(robots, dims):
  x_mid = dims[0] // 2
  y_mid = dims[1] // 2
  sum = [0,0,0,0]
  mid_pos = 0
  # render_grid(robots, dims)
  # print()
  # render_grid(robots, dims, True)
  for pos, _ in robots:
    if pos[0] < x_mid and pos[1] < y_mid:
      # print(f"Robot: {pos}, Quad: 0")
      sum[0] += 1
    elif pos[0] > x_mid and pos[1] < y_mid:
      # print(f"Robot: {pos}, Quad: 1")
      sum[1] += 1
    elif pos[0] < x_mid and pos[1] > y_mid:
      # print(f"Robot: {pos}, Quad: 2")
      sum[2] += 1
    elif pos[0] > x_mid and pos[1] > y_mid:
      # print(f"Robot: {pos}, Quad: 3")
      sum[3] += 1
    else:
      mid_pos += 1

  return sum


def part1(input_text, dims):
  parsed = parse(input_text)
  robots = tick(parsed, dims, 100)
  count = count_quads(robots, dims)
  # multiply count together
  sum = 1
  for c in count:
    sum *= c
  return sum

def symetrical(positions, dims):
  # breakpoint()
  dim_x = dims[0]
  for x, y in positions:
    alt_x = dim_x - x - 1
    if (alt_x, y) not in positions:
      return False
    
  return True

VARIANCE_TRACKER = []
AVG_VARIANCE = []

def variance(positions):
  import numpy as np

  data_x = [x for x, _ in positions]
  data_y = [y for _, y in positions]

  stdev_x = np.std(data_x)
  stdev_y = np.std(data_y)

  VARIANCE_TRACKER.append((stdev_x, stdev_y))
  sum_x = 0
  sum_y = 0
  for x, y in VARIANCE_TRACKER:
    sum_x += x
    sum_y += y

  avg_x = sum_x / len(VARIANCE_TRACKER)
  avg_y = sum_y / len(VARIANCE_TRACKER)

  global AVG_VARIANCE
  AVG_VARIANCE = [avg_x, avg_y]

  return stdev_x, stdev_y


def find_cycle(robots, dims):
  new_robots = robots
  count = 0
  while count < 10000:
    new_robots = tick(new_robots, dims, 1)
    positions = tuple(set(tuple(pos) for pos, _ in new_robots))
    v = variance(positions)
    if count > 100 and abs(v[0] - AVG_VARIANCE[0]) > 2 and abs(v[1] - AVG_VARIANCE[1]) > 2:
      print(f"High Variance {v} compared to {AVG_VARIANCE} at {count}")
      render_grid(new_robots, dims)
      print()

      return count + 1

    count += 1



def part2(input_text, dims):
  parsed = parse(input_text)
  count = find_cycle(parsed, dims)
  return count

# 101 tiles wide and 103 tiles tall (when viewed from above)
if __name__ == "__main__":
  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part1(file.read(), (101, 103)))

  with open(__file__.rsplit('/', 1)[0] + "/input.txt", 'r') as file:
    print(part2(file.read(), (101, 103)))