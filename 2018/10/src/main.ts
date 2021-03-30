class Point {
  x: number;
  y: number;
  xVel: number;
  yVel: number;

  constructor(x: number, y: number, xVel: number, yVel: number) {
    this.x = x;
    this.y = y;
    this.xVel = xVel;
    this.yVel = yVel;
  }

  step(): void {
    this.x += this.xVel;
    this.y += this.yVel;
  }

  stepBack(): void {
    this.x -= this.xVel;
    this.y -= this.yVel;
  }
}

class Advent {
  points: Point[];

  constructor(input: string) {
    this.points = [];
    // position=<-3,  6> velocity=< 2, -1>
    const r = new RegExp(
      /^position=<\s*([\-\d]+),\s*([\-\d]+)> velocity=<\s*([\-\d]+),\s*([\-\d]+)>$/,
    );
    for (const line of input.split('\n')) {
      const regExpMatch: number[] = line
        .match(r)
        .slice(1, 5)
        .map((n: string) => parseInt(n));
      // Why doesn't this work?
      // const p = new Point(...regExpMatch);
      this.points.push(
        new Point(
          regExpMatch[0],
          regExpMatch[1],
          regExpMatch[2],
          regExpMatch[3],
        ),
      );
    }
  }

  step(): void {
    this.points.map((p) => p.step());
  }

  stepBack(): void {
    this.points.map((p) => p.stepBack());
  }

  render(): string {
    const grid: boolean[][] = [];
    let maxX = null;
    let maxY = null;
    let minX = null;
    let minY = null;
    for (const p of this.points) {
      grid[p.x] ||= [];
      grid[p.x][p.y] = true;
      if (maxX == null || maxX < p.x) {
        maxX = p.x;
      }
      if (maxY == null || maxY < p.y) {
        maxY = p.y;
      }
      if (minX == null || minX > p.x) {
        minX = p.x;
      }
      if (minY == null || minY > p.y) {
        minY = p.y;
      }
    }
    let output = '';
    for (let y = minY; y <= maxY; y++) {
      for (let x = minX; x <= maxX; x++) {
        output += grid[x] && grid[x][y] ? '#' : '.';
      }
      output += '\n';
    }
    return output.trim();
  }

  compactness(): number {
    const xArr = this.points.map((p) => p.x);
    const yArr = this.points.map((p) => p.y);
    return (
      Math.max(...xArr) -
      Math.min(...xArr) +
      Math.max(...yArr) -
      Math.min(...yArr)
    );
  }

  runUntilCompact(): [number, string] {
    let compactScore: number = this.compactness();

    let i = 0;
    while (true) {
      this.step();
      const newCompactScore = this.compactness();

      if (newCompactScore > compactScore) {
        this.stepBack();
        return [i, this.render()];
      }

      compactScore = newCompactScore;

      i++;
    }
  }
}

export { Advent, Point };
