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
    if (this.keys().length == 0) return '';
    const minMax = this.minMax();
    let renderStr = '#'.repeat((minMax[1][0] - minMax[0][0] + 1) * 2 + 1);
    renderStr += '\n';
    for (let y = minMax[0][1]; y <= minMax[1][1]; y++) {
      let nextLine = '#';
      renderStr += '#';
      for (let x = minMax[0][0]; x <= minMax[1][0]; x++) {
        const cell: number | any = this.get(x, y) || 0;
        if (x == 0 && y == 0) {
          renderStr += 'X';
        } else {
          renderStr += cell != 0 ? '.' : '#';
        }
        renderStr += (cell & 4) == 4 ? '|' : '#';
        nextLine += (cell & 2) == 2 ? '-' : '#';
        nextLine += '#';
      }
      renderStr += '\n' + nextLine + '\n';
    }
    return renderStr.trim();
  }
}

class Advent {
  pathRegex: string;
  grid: Grid<number>;

  constructor(input: string) {
    this.pathRegex = input;
    this.grid = new Grid();
  }

  directionMap = {
    W: [-1, 0],
    E: [1, 0],
    S: [0, 1],
    N: [0, -1],
  };

  directionBitMap = {
    N: 1,
    S: 2,
    E: 4,
    W: 8,
  };

  reverseDirectionBitMap = {
    N: 2,
    S: 1,
    E: 8,
    W: 4,
  };

  deepCopy(obj: any): any {
    return JSON.parse(JSON.stringify(obj));
  }

  fill(path: string): number {
    const stack: [number, number][] = [];
    let branches: [number, number][] = [[0, 0]];
    let newBranches: [number, number][] = [];
    const stepGrid = new Grid<number>();
    let points = new Set<string>();

    for (const [idx, char] of path.split('').entries()) {
      console.log(
        char,
        idx,
        '/',
        path.length,
        stack.length,
        branches.length,
        this.grid.minMax()
      );
      switch (char) {
        case '^':
        case '(':
          newBranches = [];
          stack.push(this.deepCopy(branches));
          break;
        case ')':
        case '$':
          stack.pop();
          newBranches = newBranches.concat(branches);
          // console.log(char, ...branches, 'New Branches:', ...newBranches);
          points = new Set<string>();
          for (let i = 0; i < newBranches.length; i++) {
            points.add(newBranches[i].toString());
          }
          branches = [];
          for (const point of points.keys()) {
            const [x, y] = point.split(',', 2).map((n) => parseInt(n));
            branches.push([x, y]);
          }
          newBranches = branches;
          break;
        case '|':
          // console.log('NB', newBranches);
          // console.log('B', branches);
          // console.log('S', stack);
          newBranches = newBranches.concat(branches);
          branches = this.deepCopy(stack[stack.length - 1]);
          // console.log(char, ...branches, 'New Branches:', ...newBranches);
          // console.log('NB', newBranches);
          // console.log('B', branches);
          // console.log('S', stack);
          // throw "Fubar";
          break;
        default:
          for (let i = 0; i < branches.length; i++) {
            let [x, y] = branches[i];
            const currentSteps = stepGrid.get(x, y) || 0;
            const [xD, yD] = this.directionMap[char];
            const dirBit = this.directionBitMap[char];
            const revBit = this.reverseDirectionBitMap[char];
            this.grid.set(x, y, (this.grid.get(x, y) || 0) | dirBit);
            x += xD;
            y += yD;
            branches[i] = [x, y];
            this.grid.set(x, y, (this.grid.get(x, y) || 0) | revBit);
            if (stepGrid.get(x, y) == null) {
              stepGrid.set(x, y, currentSteps + 1);
            }
            // console.log(char, ...stack);
            // console.log(this.grid.render());
            // console.log(`Vals:`, stepGrid.entries());
          }
      }
    }
    // console.log(this.grid.render());
    // console.log(stepGrid.entries());
    return Math.max(...stepGrid.map.values());
  }

  // fill(path: string): number {
  //   let steps = 0;
  //   let workingBranch: [string, number, number, number][] = null;
  //   let working: [string, number, number, number][][] = null;
  //   const stack: [string, number, number, number][][][] = [];
  //   let x, y = 0;
  //   const branches: [number, number][] = [];

  //   for (let i = 0; i < path.length; i++) {
  //     const char = path[i];
  //     switch (char) {
  //       case '^':
  //       case '(':
  //         stack.push([[]]);
  //         working = stack[stack.length - 1];
  //         workingBranch = working[0];
  //         break;
  //       case ')':
  //         working = stack[stack.length - 2];
  //         workingBranch = working[working.length - 1];
  //         const prevWorking = stack.pop();
  //       case '$':
  //         break;
  //       case '|':
  //         working.push([]);
  //         workingBranch = working[working.length - 1];
  //         break;
  //       default:
  //         workingBranch.push([char, x, y, steps]);
  //     }
  //   }

  //   return steps;
  // }
}

export { Advent };
