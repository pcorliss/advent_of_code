export default class Advent {
  frequencies: number[];

  constructor(input: string) {
    this.frequencies = input.split('\n').map((n) => parseInt(n));
  }

  frequency(): number {
    return this.frequencies.reduce((acc, n) => acc + n);
  }
}
