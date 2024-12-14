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

def danger_level(robots, dims):
  count = count_quads(robots, dims)
  # multiply count together
  sum = 1
  for c in count:
    sum *= c
  return sum

def part1(input_text, dims):
  parsed = parse(input_text)
  robots = tick(parsed, dims, 100)
  return danger_level(robots, dims)

VARIANCE_TRACKER = []
SUM_VARIANCE = [0,0]
AVG_VARIANCE = []

def variance(positions):
  import numpy as np

  data_x = [x for x, _ in positions]
  data_y = [y for _, y in positions]

  var_x = np.var(data_x)
  var_y = np.var(data_y)

  VARIANCE_TRACKER.append((var_x, var_y))

  global AVG_VARIANCE
  global SUM_VARIANCE
  SUM_VARIANCE[0] += var_x
  SUM_VARIANCE[1] += var_y
  AVG_VARIANCE = [SUM_VARIANCE[0] / len(VARIANCE_TRACKER), SUM_VARIANCE[1] / len(VARIANCE_TRACKER)]

  return var_x, var_y 


def find_cycle(robots, dims):
  new_robots = robots
  count = 0
  min_danger_level = danger_level(robots, dims)
  while count < 10000:
    new_robots = tick(new_robots, dims, 1)
    new_danger_level = danger_level(new_robots, dims)
    if new_danger_level < min_danger_level:
      print(f"New Min: {new_danger_level} at {count}")
      min_danger_level = new_danger_level
    positions = tuple(set(tuple(pos) for pos, _ in new_robots))
    v = variance(positions)
    variance_threshold = 200
    if count > 100 and abs(v[0] - AVG_VARIANCE[0]) > variance_threshold and abs(v[1] - AVG_VARIANCE[1]) > variance_threshold:
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