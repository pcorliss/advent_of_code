class Advent {
  serial: number;
  grid: number[][];

  constructor(input: string) {
    this.serial = parseInt(input);
    this.grid = [];
  }

  powerLevel(x: number, y: number): number {
    // console.log(`PowerLevel Request for ${x},${y}`);
    if (this.grid[x] && this.grid[x][y]) {
      // console.log(`Cached: ${this.grid[x][y]}`);
      return this.grid[x][y];
    }
    const rackId = x + 10;
    const powerSum = (rackId * y + this.serial) * rackId;
    const powerHundDig = Math.floor(powerSum / 100) % 10;
    const powerLevel = powerHundDig - 5;
    this.grid[x] ||= [];
    this.grid[x][y] = powerLevel;
    // console.log(`Computed: ${this.grid[x][y]}`);
    return powerLevel;
  }

  blockPowerLevel(x: number, y: number, size = 3): number {
    let sum = 0;
    for (let xPos = x; xPos < x + size; xPos++) {
      for (let yPos = y; yPos < y + size; yPos++) {
        sum += this.powerLevel(xPos, yPos);
      }
    }
    return sum;
  }

  largestBlock(minSize = 3, maxSize = 3): [number, number, number] {
    let maxPower = -1000;
    let maxCoords: [number, number, number] = null;

    for (let s = minSize; s <= maxSize; s++) {
      console.log(`Size: ${s} ${maxPower} ${maxCoords}`);
      for (let x = 0; x <= 300 - s; x++) {
        for (let y = 0; y <= 300 - s; y++) {
          const powerLevel = this.blockPowerLevel(x, y, s);
          if (powerLevel > maxPower) {
            maxPower = powerLevel;
            maxCoords = [x, y, s];
          }
        }
      }
    }

    return maxCoords;
  }
}

export { Advent };
