class Advent {
  numRecipies: number;
  scores: number[];
  elves: number[];

  constructor(input: string) {
    this.numRecipies = parseInt(input);
    this.scores = [3, 7];
    this.elves = [0, 1];
  }

  create(): number[] {
    const newR = this.scores[this.elves[0]] + this.scores[this.elves[1]];
    const returnArr = [];
    if (newR > 9) {
      returnArr.push(Math.floor(newR / 10));
      returnArr.push(newR % 10);
      this.scores.push(Math.floor(newR / 10));
      this.scores.push(newR % 10);
    } else {
      returnArr.push(newR);
      this.scores.push(newR);
    }
    this.elves[0] += 1 + this.scores[this.elves[0]];
    this.elves[1] += 1 + this.scores[this.elves[1]];
    this.elves[0] %= this.scores.length;
    this.elves[1] %= this.scores.length;
    return returnArr;
  }
}

export { Advent };
