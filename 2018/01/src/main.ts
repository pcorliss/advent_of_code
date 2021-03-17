export default class Advent {
  frequencies: number[];

  constructor(input: string) {
    this.frequencies = input.split('\n').map((n) => parseInt(n));
  }

  frequency(): number {
    return this.frequencies.reduce((acc, n) => acc + n);
  }

  first_dupe(): number {
    const seen: number[] = [];
    let sum = 0;
    let i = 0;
    return 0;
    // while (true) {
    //   sum = this.frequencies.reduce((acc, n) => {
    //     const new_sum = acc + n;
    //     if (seen.includes(new_sum)) {
    //       return new_sum;
    //     }
    //     seen.push(new_sum);
    //     i += 1;
    //     if (i > 10) {
    //       throw 'Too many Iterations';
    //     }
    //     new_sum;
    //   }, sum);
    // }
  }
}
