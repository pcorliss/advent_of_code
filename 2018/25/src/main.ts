class Advent {
  points: number[][];

  constructor(input: string) {
    this.points = [];
    for (const line of input.split('\n')) {
      const point = line.split(',').map((n) => parseInt(n));
      this.points.push(point);
    }
  }

  adjacent(a: number[], b: number[]): boolean {
    let sum = 0;
    for (let i = 0; i < 4; i++) {
      sum += Math.abs(a[i] - b[i]);
    }
    return sum <= 3;
  }

  formConstellations(): number[][][] {
    const con: number[][][] = [[]];
    const available = this.points.slice();

    let counter = 0;
    let current = con[con.length - 1];
    while (available.length > 0) {
      const p = available.pop();
      if (current.length == 0) {
        current.push(p);
        counter = 0;
      } else if (current.some((mp) => this.adjacent(mp, p))) {
        current.push(p);
        counter = 0;
      } else {
        available.unshift(p);
        counter++;
        if (counter == available.length + 1) {
          con.push([]);
          current = con[con.length - 1];
          counter = 0;
        }
      }
    }
    return con;
  }
}

export { Advent };
