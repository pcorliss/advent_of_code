export default class Advent {
  polymer: string;

  constructor(input: string) {
    this.polymer = input.trim();
  }

  reduce(poly: string): string {
    let lastChar = '';
    let newPoly = '';
    let reduced = false;
    for (const curChar of poly.split('')) {
      if (
        !reduced && // haven't already reduced
        lastChar.toUpperCase() === curChar.toUpperCase() && // chars are equivalent
        lastChar !== curChar // but different cases
      ) {
        lastChar = '';
        reduced = true;
      } else {
        newPoly += lastChar;
        lastChar = curChar;
      }
    }
    return newPoly + lastChar;
  }

  reduceAll(poly: string): string {
    let lastPoly = '';
    while (lastPoly !== poly) {
      lastPoly = poly;
      poly = this.reduce(poly);
    }
    return lastPoly;
  }
}
