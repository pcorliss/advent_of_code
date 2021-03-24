export default class Advent {
  polymer: string;

  constructor(input: string) {
    this.polymer = input.trim();
  }

  reduce(poly: string): string {
    let lastChar = '';
    let newPoly = '';
    for (const curChar of poly.split('')) {
      if (
        lastChar.toUpperCase() === curChar.toUpperCase() && // chars are equivalent
        lastChar !== curChar // but different cases
      ) {
        // This isn't strictly necessary since we'll run this function multiple times, but it allows us to do more in a single pass
        lastChar = newPoly.slice(-1);
        newPoly = newPoly.slice(0, -1);
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

  optimizePoly(poly: string): string {
    let shortest = poly;
    for (let i = 0; i < 26; i++) {
      const charToRemove = String.fromCharCode(97 + i);
      const regex = new RegExp(`${charToRemove}`, 'ig');
      const newPoly = poly.replace(regex, '');
      const reduced = this.reduceAll(newPoly);
      if (shortest.length > reduced.length) {
        console.log(
          `New Shortest: Removed ${charToRemove} - Length: ${reduced.length} - Previous Shortest: ${shortest.length}`,
        );
        shortest = reduced;
      }
    }
    return shortest;
  }
}
