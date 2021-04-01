class Point {
  constructor(public x: number, public y: number) {}

  hash(): string {
    return [this.x, this.y].toString();
  }
}

class Advent {
  carts: [number, number, string, number][];
  path: string[][];
  collisions: [number, number][];

  constructor(input: string) {
    this.carts = [];
    this.path = [];
    this.collisions = [];
    let x = 0;
    let y = 0;
    for (const line of input.split('\n')) {
      this.path[y] ||= [];
      for (const char of line.split('')) {
        // console.log(`Testing: ${char} at ${x},${y}`);
        switch (char) {
          case '<':
            // this.carts.set([x, y].toString(), 'w');
            this.carts.push([x, y, 'w', 0]);
            this.path[y][x] = '-';
            break;
          case '>':
            // this.carts.set([x, y].toString(), 'e');
            this.carts.push([x, y, 'e', 0]);
            this.path[y][x] = '-';
            break;
          case 'v':
            // this.carts.set([x, y].toString(), 's');
            this.carts.push([x, y, 's', 0]);
            this.path[y][x] = '|';
            break;
          case '^':
            // this.carts.set([x, y].toString(), 'n');
            this.carts.push([x, y, 'n', 0]);
            this.path[y][x] = '|';
            break;
          default:
            if (char != ' ') {
              this.path[y][x] = char;
            }
        }
        x++;
      }
      x = 0;
      y++;
    }
  }

  directionMap = {
    n: [0, -1],
    s: [0, 1],
    e: [1, 0],
    w: [-1, 0],
  };

  // [left, stright, right]
  turnMap = [-1, 0, 1];
  directions = ['n', 'e', 's', 'w'];

  tick(): void {
    // Instructions were explicit about ordering, but we're going ot wing it for now.
    const newCarts: [number, number, string, number][] = [];
    this.carts.sort((a, b) => (a[1] - b[1]) * 1000 + a[0] - b[0]);
    while (this.carts.length > 0) {
      let [x, y, dir, turns] = this.carts.shift();
      const [xDelta, yDelta] = this.directionMap[dir];
      x += xDelta;
      y += yDelta;
      const newPos = this.path[y][x];

      let turn = 0;
      if (newPos == '+') {
        turn = this.turnMap[turns % 3];
        turns++;
      }
      if (newPos == '/') {
        turn = dir == 'e' || dir == 'w' ? -1 : 1;
      }
      if (newPos == '\\') {
        turn = dir == 'e' || dir == 'w' ? 1 : -1;
      }

      if (turn != 0) {
        let newDirIdx = (this.directions.indexOf(dir) + turn) % 4;
        if (newDirIdx < 0) {
          newDirIdx = 4 + newDirIdx;
        }
        dir = this.directions[newDirIdx];
        if (dir == null) {
          throw `Failure!!! ${dir} ${newDirIdx} ${
            this.directions.indexOf(dir) + turn
          }`;
        }
      }

      // Check for collision in this.carts && newCarts
      for (const cart of this.carts.concat(newCarts)) {
        const [cartX, cartY] = cart;
        if (cartX == x && cartY == y) {
          // console.log(`Collision!!! ${x}, ${y}`);
          this.collisions.push([x, y]);
        }
      }

      newCarts.push([x, y, dir, turns]);
    }
    this.carts = newCarts;
  }
}

export { Advent, Point };
