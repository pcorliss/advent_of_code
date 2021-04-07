class Grid<T> {
  map: Map<number, T>;

  constructor() {
    this.map = new Map();
  }

  // An Elegant Pairing Function by Matthew Szudzik @ Wolfram Research, Inc.
  // https://codepen.io/sachmata/post/elegant-pairing
  // does not handle negative numbers
  elegantPair(x: number, y: number): number {
    return x >= y ? x * x + x + y : y * y + x;
  }

  elegantUnpair(z: number): [number, number] {
    const sqrtz = Math.floor(Math.sqrt(z));
    const sqz = sqrtz * sqrtz;
    return z - sqz >= sqrtz ? [sqrtz, z - sqz - sqrtz] : [z - sqz, sqrtz];
  }

  get(x: number, y: number): T {
    return this.map.get(this.elegantPair(x, y));
  }

  set(x: number, y: number, val: T): void {
    this.map.set(this.elegantPair(x, y), val);
  }

  keys(): [number, number][] {
    return [...this.map.keys()].map((k) => this.elegantUnpair(k));
  }

  entries(): [number, number, T][] {
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
  grid: Grid<string>;
  bounds: [[number, number], [number, number]];

  constructor(input: string) {
    this.grid = new Grid();
    for (const [y, line] of input.split('\n').entries()) {
      for (const [x, char] of line.split('').entries()) {
        if (char != '.') this.grid.set(x, y, char);
      }
    }
    this.bounds = this.grid.minMax();
  }

  adjacent = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1],
  ];

  step(): void {
    const typeCount = new Grid<[number, number]>();
    for (const [x, y, v] of this.grid.entries()) {
      // console.log("TypeCount: ", typeCount.map.get(11));
      for (const [dX, dY] of this.adjacent) {
        if (
          x + dX >= this.bounds[0][0] &&
          y + dY >= this.bounds[0][1] &&
          x + dX <= this.bounds[1][0] &&
          y + dY <= this.bounds[1][1]
        ) {
          let [tree, lumber] = typeCount.get(x + dX, y + dY) || [0, 0].slice();
          // if (x + dX == 2 && y + dY == 3) console.log('Pre:', x, y, v, tree, lumber);
          if (v == '|') tree++;
          if (v == '#') lumber++;
          // if (x + dX == 2 && y + dY == 3) console.log('Pos:', x, y, v, tree, lumber);
          typeCount.set(x + dX, y + dY, [tree, lumber]);
          // if (typeCount.get(2,3) != null) {
          //   console.log(v, x, dX, y, dY, tree, lumber);
          //   console.log(x + dX, y + dY, [tree, lumber]);
          //   console.log(typeCount.elegantPair(3, -1), this.grid.elegantPair(3, -1));
          //   throw "Cake!!!";
          // }
        }
      }
    }

    const newGrid = new Grid<string>();
    for (const [x, y, v] of this.grid.entries()) {
      const [tree, lumber] = typeCount.get(x, y) || [0, 0];
      // if (x == 2 && y == 3) console.log('Tree & Lumber & val: ', tree, lumber, v);
      if (v == '#') {
        if (tree > 0 && lumber > 0) newGrid.set(x, y, v);
      } else if (v == '|') {
        if (lumber >= 3) {
          newGrid.set(x, y, '#');
        } else {
          newGrid.set(x, y, v);
        }
      } else {
        newGrid.set(x, y, v);
      }
    }

    for (const [x, y, [tree, lumber]] of typeCount.entries()) {
      if (tree >= 3 && this.grid.get(x, y) == null) newGrid.set(x, y, '|');
    }
    this.grid = newGrid;
  }

  valueCount(): Map<string, number> {
    const valCount = new Map();
    for (const v of this.grid.map.values()) {
      const count = (valCount.get(v) || 0) + 1;
      valCount.set(v, count);
    }
    return valCount;
  }

  findWithCycle(n: number): number {
    const vals: number[] = [];
    const possible: number[] = [];

    for (let i = 0; i <= 1000; i++) {
      const val = [...this.valueCount().values()].reduce(
        (acc, v) => acc * v,
        1,
      );
      if (val == 1) {
        throw 'Val of 1!!!';
      }
      const idx = vals.indexOf(val);
      vals.push(val);
      if (idx > 0) {
        if ((n - i) % (i - idx) == 0) {
          console.log('Possible cycle @', i + (i - idx), i, idx, val);
          possible.push(i + (i - idx));
          if (possible.includes(i)) {
            console.log('Prediction Correct: ', possible, i, idx, val);
            return val;
          }
        }
      }
      this.step();
      // console.log(this.grid.render() + '\n\n');
    }
    return 0;
  }
}

export { Advent };
