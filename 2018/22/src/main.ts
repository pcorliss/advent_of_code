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
}

export { Advent };
