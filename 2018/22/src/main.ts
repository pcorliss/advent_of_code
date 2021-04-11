class Grid<T> {
  map: Map<string, T>;

  constructor() {
    this.map = new Map();
  }

  pair(x: number, y: number): string {
    return [x, y].toString();
  }

  unpair(z: string): [number, number] {
    const [a, b] = z.split(',', 2).map((n) => parseInt(n));
    return [a, b];
  }

  get(x: number, y: number): T {
    return this.map.get(this.pair(x, y));
  }

  set(x: number, y: number, val: T): void {
    this.map.set(this.pair(x, y), val);
  }

  keys(): [number, number][] {
    return [...this.map.keys()].map((k) => this.unpair(k));
  }

  entries(): [number, number, T][] {
    return [...this.map.entries()].map(([k, v]) => {
      const [x, y] = this.unpair(k);
      return [x, y, v];
    });
  }

  minMax(): [[number, number], [number, number]] {
    const minMax: [[number, number], [number, number]] = [
      [Number.MAX_SAFE_INTEGER, Number.MAX_SAFE_INTEGER],
      [Number.MIN_SAFE_INTEGER, Number.MIN_SAFE_INTEGER],
    ];
    for (const [x, y] of this.keys()) {
      if (x > minMax[1][0]) minMax[1][0] = x;
      if (x < minMax[0][0]) minMax[0][0] = x;
      if (y > minMax[1][1]) minMax[1][1] = y;
      if (y < minMax[0][1]) minMax[0][1] = y;
    }
    return minMax;
  }

  render(): string {
    const minMax = this.minMax();
    let renderStr = '';
    for (let y = minMax[0][1]; y <= minMax[1][1]; y++) {
      for (let x = minMax[0][0]; x <= minMax[1][0]; x++) {
        renderStr += this.get(x, y) || '.';
      }
      renderStr += '\n';
    }
    return renderStr.trim();
  }
}

class Advent {
  grid: Grid<number>;
  depth: number;
  origin: [number, number];
  target: [number, number];

  constructor(input: string) {
    this.grid = new Grid<number>();
    this.origin = [0, 0];
    const [d, t] = input.split('\n');
    this.depth = parseInt(d.split(': ')[1]);
    const [x, y] = t
      .split(': ')[1]
      .split(',')
      .map((n) => parseInt(n));
    this.target = [x, y];
  }

  geologic(x: number, y: number): number {
    if ((x <= 0 && y <= 0) || (x == this.target[0] && y == this.target[1]))
      return 0;
    if (y <= 0) return 16807 * x;
    if (x <= 0) return 48271 * y;
    return this.erosion(x - 1, y) * this.erosion(x, y - 1);
  }

  erosion(x: number, y: number): number {
    let e = this.grid.get(x, y);
    if (e == null) {
      e = (this.geologic(x, y) + this.depth) % 20183;
      this.grid.set(x, y, e);
    }
    return e;
  }

  conditionLevel(x: number, y: number): number {
    return this.erosion(x, y) % 3;
  }

  conditionMap = ['.', '=', '|'];

  // Could use an enum here as the return type
  condition(x: number, y: number): string {
    return this.conditionMap[this.conditionLevel(x, y)];
  }

  risk(): number {
    const [xMin, yMin] = this.origin;
    const [xMax, yMax] = this.target;
    let sum = 0;
    for (let y = yMin; y <= yMax; y++) {
      for (let x = xMin; x <= xMax; x++) {
        sum += this.conditionLevel(x, y);
      }
    }
    return sum;
  }

  // This would be more efficient as a bit set
  allowedEquip = [
    new Set([2, 1]), // Rocky - Climbing, Torch
    new Set([2, 0]), // Wet - Climbing, Neither
    new Set([1, 0]), // Narrow - Torch, Neither
  ];

  move(
    xStart: number,
    yStart: number,
    equip: number,
    xDest: number,
    yDest: number,
  ): [number, number] {
    // In rocky regions, you can use the climbing gear or the torch.
    // In wet regions, you can use the climbing gear or neither tool.
    // In narrow regions, you can use the torch or neither tool.
    // rocky == '.' == 0 == [2, 1]
    // wet == '=' == 1 == [2, 0]
    // narrow == '|' == 2 == [1, 0]

    const curCon = this.conditionLevel(xStart, yStart);
    const destCon = this.conditionLevel(xDest, yDest);

    if (xDest == this.target[0] && yDest == this.target[1]) {
      if (equip == 1) {
        return [1, 1];
      }
      const newEquip = [...this.allowedEquip[curCon]].find((n) => n != equip);
      if (newEquip == 1) {
        return [8, 1];
      } else {
        return [15, 1];
      }
    }

    if (curCon == destCon) return [1, equip];
    if (this.allowedEquip[destCon].has(equip)) return [1, equip];

    const newEquip = [...this.allowedEquip[curCon]].find((n) => n != equip);
    return [8, newEquip];
  }

  adjacent = [
    [-1, 0],
    [1, 0],
    [0, 1],
    [0, -1],
  ];

  findPath(xDest: number, yDest: number): number {
    // You start at 0,0 (the mouth of the cave) with the torch equipped
    let minutes = 0;
    // [x, y, equip]
    const paths: [number, number, number][][] = [[[0, 0, 1]]];
    // visited[x][y][equip] == true
    const visited: boolean[][][] = [[[]]];
    for (let y = 0; y <= yDest + 1000; y++) {
      for (let x = 0; x <= xDest + 1000; x++) {
        visited[x] ||= [];
        visited[x][y] ||= [];
      }
    }

    while (true) {
      if (minutes > 10000) {
        console.log(paths);
        // console.log(visited);
        throw 'Minutes Exceeded!!!';
      }
      console.log('Mins: ', minutes, 'Num Paths:', paths[minutes].length);
      paths[minutes] ||= [];
      paths[1 + minutes] ||= [];
      paths[8 + minutes] ||= [];
      paths[15 + minutes] ||= [];
      for (const [x, y, e] of paths[minutes]) {
        if (x == xDest && y == yDest) return minutes;
        if (!visited[x][y][e]) {
          visited[x][y][e] = true;
          for (const [xD, yD] of this.adjacent) {
            const [newX, newY] = [x + xD, y + yD];
            if (
              newX >= 0 &&
              newY >= 0 // &&
              // newX < xDest + 10 &&
              // newY < yDest + 10
            ) {
              const [min, newE] = this.move(x, y, e, newX, newY);
              if (!visited[newX][newY][newE]) {
                paths[min + minutes].push([newX, newY, newE]);
                // console.log('Move and Push:', newX, newY, newE, min + minutes);
              }
            }
          }
        }
      }
      minutes++;
    }

    return minutes;
  }
}

export { Advent };
