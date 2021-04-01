class Advent {
  plants: Set<number>;
  rules: Map<string, string>;

  constructor(input: string) {
    this.plants = new Set<number>();
    this.rules = new Map<string, string>();

    const lines = input.split('\n');
    for (const line of lines) {
      if (this.plants.size == 0) {
        const [, initPlants] = line.split(': ');
        let i = 0;
        for (const p of initPlants.split('')) {
          if (p == '#') {
            this.plants.add(i);
          }
          i++;
        }
      }

      if (line.includes(' => ')) {
        const [lookup, result] = line.split(' => ');
        this.rules.set(lookup, result);
      }
    }
  }

  step(): void {
    const min = Math.min(...this.plants) - 4;
    const max = Math.max(...this.plants) + 4;
    const newPlants = new Set<number>();
    for (let i = min; i <= max; i++) {
      const lookup = [
        this.plants.has(i) ? '#' : '.',
        this.plants.has(i + 1) ? '#' : '.',
        this.plants.has(i + 2) ? '#' : '.',
        this.plants.has(i + 3) ? '#' : '.',
        this.plants.has(i + 4) ? '#' : '.',
      ].join('');
      if (this.rules.get(lookup) == '#') {
        newPlants.add(i + 2);
      }
    }
    this.plants = newPlants;
  }
}

export { Advent };
