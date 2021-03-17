export default class Advent {
  frequencies: number[];

  constructor(input: string) {
    this.frequencies = input.split('\n').map((n) => parseInt(n));
  }

  frequency(): number {
    return this.frequencies.reduce((acc, n) => acc + n);
  }

  first_dupe(): number {
    // const seen: number[] = [];
    const seen = new Set();
    let sum = 0;
    let i = 0;
    while (true) {
      for (const n of this.frequencies) {
        i += 1;
        sum += n;
        if (seen.has(sum)) {
          return sum;
        }
        seen.add(sum);
        if (i > 10000000) {
          throw 'Error: too many iterations!!!';
        }
      }
    }
  }
}
