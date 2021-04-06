class Grid {
  map: Map<number, string>;

  constructor() {
    this.map = new Map();
  }

  // Only works for positive numbers
  cantorNumber(a: number, b: number): number {
    return 0.5 * (a + b) * (a + b + 1) * b;
  }

  // An Elegant Pairing Function by Matthew Szudzik @ Wolfram Research, Inc.
  // https://codepen.io/sachmata/post/elegant-pairing
  elegantPair(x: number, y: number): number {
    return x >= y ? x * x + x + y : y * y + x;
  }

  elegantUnpair(z: number): [number, number] {
    const sqrtz = Math.floor(Math.sqrt(z));
    const sqz = sqrtz * sqrtz;
    return z - sqz >= sqrtz ? [sqrtz, z - sqz - sqrtz] : [z - sqz, sqrtz];
  }

  get(x: number, y: number): string {
    return this.map.get(this.elegantPair(x, y));
  }

  set(x: number, y: number, val: string): void {
    this.map.set(this.elegantPair(x, y), val);
  }

  keys(): [number, number][] {
    return [...this.map.keys()].map((k) => this.elegantUnpair(k));
  }

  entries(): [number, number, string][] {
    return [...this.map.entries()].map(([k, v]) => {
      const [x, y] = this.elegantUnpair(k);
      return [x, y, v];
    });
  }

  minMax(): [[number, number], [number, number]] {
    const minMax: [[number, number], [number, number]] = [
      [Number.MAX_SAFE_INTEGER, Number.MAX_SAFE_INTEGER],
      [Number.MIN_SAFE_INTEGER, Number.MIN_SAFE_INTEGER],
    ];
    for (const [x, y] of this.keys()) {
      if (x > minMax[1][0]) {
        minMax[1][0] = x;
      }
      if (x < minMax[0][0]) {
        minMax[0][0] = x;
      }
      if (y > minMax[1][1]) {
        minMax[1][1] = y;
      }
      if (y < minMax[0][1]) {
        minMax[0][1] = y;
      }
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
  spring: [number, number];
  grid: Grid;

  constructor(input: string) {
    this.grid = new Grid();
    this.spring = [500, 0];
    this.grid.set(500, 0, '+');
    for (const line of input.split('\n')) {
      const [a, b] = line.split(', ');
      const [aId, aVal] = a.split('=');
      const [, bVal] = b.split('=');
      const [bValsStart, bValsEnd] = bVal.split('..').map((n) => parseInt(n));
      for (let i = bValsStart; i <= bValsEnd; i++) {
        const aValInt = parseInt(aVal);
        if (aId == 'x') {
          this.grid.set(aValInt, i, '#');
        } else {
          this.grid.set(i, aValInt, '#');
        }
      }
    }
  }

  impassable = ['~', '#'];

  pourPrime(): void {
    const minMax = this.grid.minMax();
    let paths: [number, number][] = [this.spring];
    while (paths.length > 0) {
      // console.log(this.grid.render());
      console.log('Paths:', paths);
      if (paths.length > 20) {
        throw 'Too many paths!!!';
      }
      const newPaths = [];
      for (const path of paths) {
        let [x, y] = path;
        // go downwards until barrier reached, mark along way
        y++;
        let pos = this.grid.get(x, y);
        while (!this.impassable.includes(pos) && y <= minMax[1][1]) {
          this.grid.set(x, y, '|');
          y++;
          pos = this.grid.get(x, y);
        }
        // next if bounds check on y val
        if (y <= minMax[1][1]) {
          y--;
          // explore left and right and mark along way
          let maxX = x;
          let minX = x;
          let cont = true;
          let leftOpen = false;
          let rightOpen = false;

          while (cont) {
            const left = this.grid.get(minX - 1, y);
            const right = this.grid.get(maxX + 1, y);
            const leftBase = this.grid.get(minX - 1, y + 1);
            const rightBase = this.grid.get(maxX + 1, y + 1);
            cont = false;

            if (
              !this.impassable.includes(left) &&
              this.impassable.includes(leftBase)
            ) {
              minX--;
              this.grid.set(minX, y, '|');
              cont = true;
            } else if (!this.impassable.includes(leftBase)) {
              this.grid.set(minX - 1, y, '|');
              leftOpen = true;
            }

            if (
              !this.impassable.includes(right) &&
              this.impassable.includes(rightBase)
            ) {
              maxX++;
              this.grid.set(maxX, y, '|');
              cont = true;
            } else if (!this.impassable.includes(rightBase)) {
              this.grid.set(maxX + 1, y, '|');
              rightOpen = true;
            }
          }

          // if barriers, fill, newPath.push([x, y - 1])
          if (!leftOpen && !rightOpen) {
            for (let j = minX; j <= maxX; j++) {
              this.grid.set(j, y, '~');
            }
            newPaths.push([x, y - 1]);
          }

          // if no barrier on left, newPath.push([minX, y])
          // if no barrier on right, newPath.push([maxX, y])
          if (leftOpen) {
            // console.log("Left Open: ", minX, y);
            newPaths.push([minX - 1, y]);
          }

          if (rightOpen) {
            // console.log("Right Open: ", maxX, y);
            newPaths.push([maxX + 1, y]);
          }
        }
      }

      const uniquePaths: Set<number> = new Set();
      for (const [x, y] of newPaths) {
        uniquePaths.add(this.grid.elegantPair(x, y));
      }

      paths = [...uniquePaths].map((pair) => this.grid.elegantUnpair(pair));
    }
  }

  wetTiles(): number {
    return [...this.grid.map.values()].reduce((acc, v) => {
      return (acc += v == '~' || v == '|' ? 1 : 0);
    }, 0);
  }

  pour(n: number): void {
    let [x, y] = this.spring;
    const minMax = this.grid.minMax();
    y++;
    for (let i = 0; i < n; i++) {
      let pos = this.grid.get(x, y);
      while (!this.impassable.includes(pos)) {
        this.grid.set(x, y, '|');
        y++;
        pos = this.grid.get(x, y);
      }

      // OK, we're at a horizontal wall, spread left & right looking for escape
      y--;
      let maxX = x;
      let minX = x;
      let cont = true;
      while (cont) {
        const left = this.grid.get(minX - 1, y);
        const right = this.grid.get(maxX + 1, y);
        const leftBase = this.grid.get(minX - 1, y + 1);
        const rightBase = this.grid.get(maxX + 1, y + 1);
        cont = false;
        if (
          !this.impassable.includes(left) &&
          this.impassable.includes(leftBase)
        ) {
          minX--;
          this.grid.set(minX, y, '|');
          cont = true;
        }
        if (
          !this.impassable.includes(right) &&
          this.impassable.includes(rightBase)
        ) {
          maxX++;
          this.grid.set(maxX, y, '|');
          cont = true;
        }
        if (
          !this.impassable.includes(rightBase) ||
          !this.impassable.includes(leftBase)
        ) {
          cont = false;
          // waterfall = true;
        }
      }

      if (maxX == x) {
        this.grid.set(minX, y, '~');
      } else {
        this.grid.set(maxX, y, '~');
      }
      // maxX == x
      // minX == maxX

      // if escape reset i and pos
      // if no escape fill basin until full and reset pos

      // let dir = i % 2 == 0 ? -1 : 1;
      // pos = this.grid.get(x + dir, y);
      // let downPos = this.grid.get(x + dir, y + 1);
    }
  }
}

export { Advent };
