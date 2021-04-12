class Grid<T> {
  map: Map<string, T>;

  constructor() {
    this.map = new Map();
  }

  pair(x: number, y: number, z: number): string {
    return [x, y, z].toString();
  }

  unpair(z: string): [number, number, number] {
    const [a, b, c] = z.split(',', 3).map((n) => parseInt(n));
    return [a, b, c];
  }

  get(x: number, y: number, z: number): T {
    return this.map.get(this.pair(x, y, z));
  }

  set(x: number, y: number, z: number, val: T): void {
    this.map.set(this.pair(x, y, z), val);
  }

  keys(): [number, number, number][] {
    return [...this.map.keys()].map((k) => this.unpair(k));
  }

  entries(): [number, number, number, T][] {
    return [...this.map.entries()].map(([k, v]) => {
      const [x, y, z] = this.unpair(k);
      return [x, y, z, v];
    });
  }

  // minMax(): [[number, number], [number, number]] {
  //   const minMax: [[number, number], [number, number]] = [
  //     [Number.MAX_SAFE_INTEGER, Number.MAX_SAFE_INTEGER],
  //     [Number.MIN_SAFE_INTEGER, Number.MIN_SAFE_INTEGER],
  //   ];
  //   for (const [x, y] of this.keys()) {
  //     if (x > minMax[1][0]) minMax[1][0] = x;
  //     if (x < minMax[0][0]) minMax[0][0] = x;
  //     if (y > minMax[1][1]) minMax[1][1] = y;
  //     if (y < minMax[0][1]) minMax[0][1] = y;
  //   }
  //   return minMax;
  // }

  // render(): string {
  //   const minMax = this.minMax();
  //   let renderStr = '';
  //   for (let y = minMax[0][1]; y <= minMax[1][1]; y++) {
  //     for (let x = minMax[0][0]; x <= minMax[1][0]; x++) {
  //       renderStr += this.get(x, y) || '.';
  //     }
  //     renderStr += '\n';
  //   }
  //   return renderStr.trim();
  // }
}

class Advent {
  grid: Grid<number>;

  constructor(input: string) {
    this.grid = new Grid<number>();
    for (const line of input.split('\n')) {
      const elements = line.split(', ', 2);
      const [[, posStr], [, rStr]] = elements.map((e) => e.split('=', 2));
      const [x, y, z] = posStr
        .replace(/[<>]/g, '')
        .split(',', 3)
        .map((n) => parseInt(n));
      const r = parseInt(rStr);
      // console.log(x, y, z, r);
      // console.log(this.grid.map);
      this.grid.set(x, y, z, r);
    }
  }

  strongestBot(): [number, number, number, number] {
    let maxRangeBot: [number, number, number, number] = [-1, -1, -1, -Infinity];
    for (const bot of this.grid.entries()) {
      if (bot[3] > maxRangeBot[3]) maxRangeBot = bot;
    }
    return maxRangeBot;
  }

  inRange(
    x: number,
    y: number,
    z: number,
    r: number,
  ): [number, number, number, number][] {
    return [...this.grid.entries()].filter((bot) => {
      const [xB, yB, zB] = bot;
      return Math.abs(x - xB) + Math.abs(y - yB) + Math.abs(z - zB) <= r;
    });
  }
}

export { Advent };
