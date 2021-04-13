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

  minMax(): [[number, number, number], [number, number, number]] {
    const minMax: [[number, number, number], [number, number, number]] = [
      [
        Number.MAX_SAFE_INTEGER,
        Number.MAX_SAFE_INTEGER,
        Number.MAX_SAFE_INTEGER,
      ],
      [
        Number.MIN_SAFE_INTEGER,
        Number.MIN_SAFE_INTEGER,
        Number.MIN_SAFE_INTEGER,
      ],
    ];
    for (const [x, y, z] of this.keys()) {
      if (x > minMax[1][0]) minMax[1][0] = x;
      if (x < minMax[0][0]) minMax[0][0] = x;
      if (y > minMax[1][1]) minMax[1][1] = y;
      if (y < minMax[0][1]) minMax[0][1] = y;
      if (z > minMax[1][2]) minMax[1][2] = z;
      if (z < minMax[0][2]) minMax[0][2] = z;
    }
    return minMax;
  }

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

import { Queue } from 'prioqueue';

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

  cubeIntersections(x: number, y: number, z: number, d: number): number {
    const dim = d - 1;
    const [xC, yC, zC] = [
      x + Math.floor(dim / 2),
      y + Math.floor(dim / 2),
      z + Math.floor(dim / 2),
    ];
    let bug = false;
    if (x == 10 && y == 10 && z == 10 && d == 3) bug = true;
    if (bug) console.log('Center: ', xC, yC, zC);

    return [...this.grid.entries()].reduce((count, bot) => {
      const [xB, yB, zB, r] = bot;
      // within the bounding box
      if (
        xB >= x &&
        xB < x + d &&
        yB >= y &&
        yB < y + d &&
        zB >= z &&
        zB < z + d
      ) {
        if (bug) console.log('Point In Grid:', xB, yB, zB, '<', d);
        return count + 1;
      }

      const distToCenter =
        Math.abs(xC - xB) + Math.abs(yC - yB) + Math.abs(zC - zB);
      if (distToCenter - dim * 3 <= r) {
        if (bug) {
          console.log(
            'distCenter:',
            xB,
            yB,
            zB,
            distToCenter,
            '-',
            dim,
            '=',
            distToCenter - dim,
            '<=',
            r,
          );
        }
        return count + 1;
      }

      if (bug) {
        console.log('NoMatch:', xB, yB, zB, r, distToCenter - dim);
      }
      return count;
    }, 0);
  }

  octoChop(
    x: number,
    y: number,
    z: number,
    d: number,
  ): [number, number, number, number][] {
    const a = Math.ceil(d / 2);
    const points: [number, number, number, number][] = [
      [x, y, z, a],
      [x + a, y, z, a],
      [x, y + a, z, a],
      [x, y, z + a, a],
      [x + a, y + a, z, a],
      [x + a, y, z + a, a],
      [x, y + a, z + a, a],
      [x + a, y + a, z + a, a],
    ];
    return points;
  }

  solver(): [number, number, number, number] {
    const [[minX, minY, minZ], [maxX, maxY, maxZ]] = this.grid.minMax();
    console.log('Min: ', minX, minY, minZ);
    console.log('Max: ', maxX, maxY, maxZ);
    const maxDim = Math.max(maxX - minX, maxY - minY, maxZ - minZ);
    console.log('MaxDim:', maxDim);

    const q = new Queue<[number, number, number, number]>(
      (a, b) => a.priority - b.priority,
    );
    // We're not going to worry that for now we rely on regular sized cubes
    const initScore = this.cubeIntersections(minX, minY, minZ, maxDim);
    q.enqueue(initScore, [minX, minY, minZ, maxDim]);

    const candidates: [number, number, number, number][] = [];
    let bestScore = 0;
    const seen = new Set<string>();

    let i = 0;
    while (true) {
      const item = q.dequeue();
      console.log(
        'Testing: ',
        item,
        'Candidates:',
        candidates.length,
        'Best:',
        bestScore,
      );
      const o = item.value;

      // return op should be up here
      if (candidates.length > 0 && bestScore > item.priority) {
        // console.log('Candidates: ', candidates);
        return candidates.sort((a, b) => {
          const [aX, aY, aZ] = a;
          const [bX, bY, bZ] = b;
          return aX + aY + aZ - (bX + bY + bZ);
        })[0];
      }

      if (!seen.has(o.toString())) {
        seen.add(o.toString());
        if (o[3] == 1) {
          const [x, y, z] = o;
          const scored = this.scoreTinyCube(x, y, z);
          if (scored[3] >= bestScore) {
            candidates.push(scored);
            bestScore = scored[3];
          }
        } else {
          for (const oct of this.octoChop(...o)) {
            const score = this.cubeIntersections(...oct);
            // console.log('Score:', score, 'Cube: ', oct);
            q.enqueue(score, oct);
          }
        }
        i++;
        if (i > 10000000) {
          // return [0, 0, 0, 0];
          throw 'Too many iterations!!!';
        }
      }
    }
  }

  scoreTinyCube(
    x: number,
    y: number,
    z: number,
  ): [number, number, number, number] {
    const points = [
      [x, y, z],
      [x + 1, y, z],
      [x, y + 1, z],
      [x, y, z + 1],
      [x + 1, y + 1, z],
      [x + 1, y, z + 1],
      [x, y + 1, z + 1],
      [x + 1, y + 1, z + 1],
    ];

    const scoredPoints: [number, number, number, number][] = points.map((p) => {
      const [xP, yP, zP] = p;
      const score = [...this.grid.entries()].reduce((acc, bot) => {
        const [xB, yB, zB, r] = bot;
        if (Math.abs(xP - xB) + Math.abs(yP - yB) + Math.abs(zP - zB) <= r) {
          return acc + 1;
        } else {
          return acc;
        }
      }, 0);
      return [xP, yP, zP, score];
    });
    // console.log('Scored:', scoredPoints);
    return scoredPoints.sort((a, b) => b[3] - a[3])[0];
  }
}

export { Advent };
