type Actor = {
  x: number;
  y: number;
  hp: number;
  elf: boolean;
  goblin: boolean;
  t: string;
};

class Advent {
  grid: (boolean | Actor)[][];
  actors: Actor[];

  constructor(input: string) {
    this.actors = [];
    this.grid = input.split('\n').map((line, y) => {
      return line.split('').map((char, x) => {
        if (char == 'G' || char == 'E') {
          this.actors.push({
            x: x,
            y: y,
            hp: 200,
            elf: char == 'E',
            goblin: char == 'G',
            t: char,
          });
          return this.actors[this.actors.length - 1];
        }
        return char != '#';
      });
    });
  }

  deltas = [
    [0, -1],
    [-1, 0],
    [1, 0],
    [0, 1],
  ];

  move(actor: Actor): void {
    // identifying all possible targets
    const enemies = this.actors.filter((a) => a.t != actor.t);
    // identifies all of the open squares (.) that are in range of each target;
    const openSquares: [number, number][] = [];
    for (const e of enemies) {
      for (const [xD, yD] of this.deltas) {
        const [x, y] = [xD + e.x, yD + e.y];
        // return if I am already adjacent to a target
        if (x == actor.x && y == actor.y) {
          return;
        }
        // If this space is open
        if (this.grid[y][x] === true) {
          openSquares.push([x, y]);
        }
      }
    }
    // return if there are no adjacent squares open to a target
    if (openSquares.length == 0) {
      return;
    }
    // DFS to find reachable
    // any ties sort by readable order (y * 1000 + x)
  }

  attack(actor: Actor): void {}
  round(): void {}
}

export { Advent };
