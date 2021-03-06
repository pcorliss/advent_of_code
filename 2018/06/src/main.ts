export default class Advent {
  points: number[][];

  constructor(input: string) {
    this.points = [];
    for (const line of input.split('\n')) {
      this.points.push(line.split(', ').map((n) => parseInt(n)));
    }
  }

  boundingBox(): number[][] {
    let min_x, min_y, max_x, max_y: number;
    for (const point of this.points) {
      const [x, y] = point;
      if (!min_x || min_x > x) {
        min_x = x;
      }
      if (!min_y || min_y > y) {
        min_y = y;
      }
      if (!max_x || max_x < x) {
        max_x = x;
      }
      if (!max_y || max_y < y) {
        max_y = y;
      }
    }
    return [
      [min_x, min_y],
      [max_x, max_y],
    ];
  }

  // TODO: Add caching if speed is a problem
  nearestPoint(x: number, y: number): number {
    let nearest = null;
    let nearestDist = null;
    let i = 0;
    for (const point of this.points) {
      const dist = Math.abs(x - point[0]) + Math.abs(y - point[1]);
      // console.log(`Point: ${i} - Dist: ${dist} to ${x}, ${y}`);
      if (nearestDist == null || nearestDist > dist) {
        nearestDist = dist;
        nearest = i;
      } else if (nearestDist === dist) {
        nearest = null;
      }
      i += 1;
    }
    return nearest;
  }

  // Map<pointIdx, nearestCount>
  gridCalc(growth: number): Map<number, number> {
    const count = new Map<number, number>();
    const [[min_x, min_y], [max_x, max_y]] = this.boundingBox();
    for (let x = min_x - growth; x <= max_x + growth; x++) {
      for (let y = min_y - growth; y <= max_y + growth; y++) {
        const nearest = this.nearestPoint(x, y);
        const currentCount = count.get(nearest) || 0;
        count.set(nearest, currentCount + 1);
      }
    }
    return count;
  }

  findNonInfinitePoints(): number[] {
    const startingGrid = this.gridCalc(0);
    const biggerGrid = this.gridCalc(1);
    const nonInfinite = [];
    for (const [pointIdx, count] of startingGrid.entries()) {
      if (count == biggerGrid.get(pointIdx)) {
        nonInfinite.push(pointIdx);
      }
    }
    return nonInfinite;
  }

  largestNonInfiniteArea(): number {
    const areaCounts = this.gridCalc(0);
    let maxArea = 0;
    for (const pointIdx of this.findNonInfinitePoints()) {
      if (areaCounts.get(pointIdx) > maxArea) {
        maxArea = areaCounts.get(pointIdx);
      }
    }
    return maxArea;
  }

  sumDistance(x: number, y: number): number {
    return this.points.reduce(
      (sum: number, point: number[]) =>
        sum + Math.abs(point[0] - x) + Math.abs(point[1] - y),
      0,
    );
  }

  safeArea(dist: number): number {
    let count = 0;
    const [[min_x, min_y], [max_x, max_y]] = this.boundingBox();
    const growth = Math.ceil(Math.sqrt(dist));

    for (let x = min_x - growth; x <= max_x + growth; x++) {
      for (let y = min_y - growth; y <= max_y + growth; y++) {
        if (this.sumDistance(x, y) < dist) {
          count += 1;
        }
      }
    }

    return count;
  }
}
