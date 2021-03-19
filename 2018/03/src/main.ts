export default class Advent {
  claims: number[][];
  grid: number[][][];

  constructor(input: string) {
    this.claims = [];
    this.grid = [];
    for (let i = 0; i < 1000; i++) {
      const arr = [];
      this.grid.push(arr);
      for (let j = 0; j < 1000; j++) {
        arr.push([]);
      }
    }
    const claimRegex = /^\#\d+ @ (\d+),(\d+): (\d+)x(\d+)$/;
    for (const line of input.split('\n')) {
      claimRegex.test(line);
      const res = line.match(claimRegex);
      res.shift();
      const nums = Array.from(res).map((n) => parseInt(n));
      this.claims.push(nums);
    }
  }

  fillGrid(): void {
    let i = 1;
    for (const claim of this.claims) {
      const [xStart, yStart, w, h] = claim;
      for (let x = xStart; x < xStart + w; x++) {
        for (let y = yStart; y < yStart + h; y++) {
          this.grid[x][y].push(i);
        }
      }
      i++;
    }
  }

  overlapCount(): number {
    let count = 0;
    for (let i = 0; i < 1000; i++) {
      for (let j = 0; j < 1000; j++) {
        if (this.grid[i][j].length > 1) {
          count++;
        }
      }
    }
    return count;
  }

  noOverlaps(): number {
    let i = 1;
    for (const claim of this.claims) {
      const [xStart, yStart, w, h] = claim;
      let overlaps = false;
      for (let x = xStart; x < xStart + w && !overlaps; x++) {
        for (let y = yStart; y < yStart + h && !overlaps; y++) {
          if (this.grid[x][y].length > 1) {
            overlaps = true;
          }
        }
      }
      if (!overlaps) {
        return i;
      }
      i++;
    }
    return 0;
  }
}
