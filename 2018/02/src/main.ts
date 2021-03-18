export default class Advent {
  boxes: string[];

  constructor(input: string) {
    this.boxes = input.split('\n');
  }

  charCount(boxId: string): Map<string, number> {
    const m = new Map<string, number>();

    for (const char of boxId.split('')) {
      const current_count = m.get(char) || 0;
      m.set(char, current_count + 1);
    }

    return m;
  }

  checksum(): number {
    const charCounts: number[] = [];

    for (const boxId of this.boxes) {
      const vals = this.charCount(boxId).values();
      const counts = new Set<number>();
      for (const v of vals) {
        counts.add(v);
      }
      for (const v of counts) {
        charCounts[v] ||= 0;
        charCounts[v] += 1;
      }

      // console.log(`BoxId: ${boxId} - Counts: ${Array.from(counts)}`);
    }
    return charCounts[2] * charCounts[3];
  }

  levenshtein(strA: string, strB: string): number {
    let charsA = strA.split('');
    let charsB = strB.split('');
    if (charsA.length < charsB.length) {
      const tmp = charsB;
      charsB = charsA;
      charsA = tmp;
    }

    let distance = 0;
    for (const i in charsA) {
      if (charsA[i] != charsB[i]) {
        distance++;
      }
    }

    return distance;
  }

  mostSimilar(): string[] {
    let minBoxId: string[] = [];
    let minDistance = 999;

    // Faster than the following
    // for (const boxIdA of this.boxes) {
    //   for (const boxIdB of this.boxes) {
    for (let i = 0; i < this.boxes.length; i++) {
      const boxIdA = this.boxes[i];
      for (let j = i + 1; j < this.boxes.length; j++) {
        const boxIdB = this.boxes[j];
        const l = this.levenshtein(boxIdA, boxIdB);
        if (minDistance > l) {
          minDistance = l;
          minBoxId = [boxIdA, boxIdB];
        }
      }
    }
    return minBoxId;
  }
}
