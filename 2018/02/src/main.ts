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
}
