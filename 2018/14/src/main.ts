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

  indexOfSubArray(lookingFor: number[]): number {
    let subArray = this.scores.slice(-lookingFor.length);
    // console.log(`Sub:`, subArray);
    if (subArray.every((v, i) => v === lookingFor[i])) {
      return this.scores.length - lookingFor.length;
    }
    subArray = this.scores.slice(-(lookingFor.length + 1), -1);
    // console.log(`Sub:`, subArray);
    if (subArray.every((v, i) => v === lookingFor[i])) {
      return this.scores.length - lookingFor.length - 1;
    }

    return -1;
  }

  createUntil(lookingFor: number[]): number {
    let i = 0;
    while (true) {
      this.create();
      const idx = this.indexOfSubArray(lookingFor);
      if (idx != -1) {
        return idx;
      }
      i++;
      // if (i > 10000000) {
      //   throw 'Too many iterations!!!';
      // }
    }
    return 0;
  }
}

export { Advent };
