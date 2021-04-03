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

  render(): string {
    return this.grid
      .map((line) => {
        return line
          .map((e) => {
            switch (e) {
              case false:
                return '#';
              case true:
                return '.';
              default:
                return e.t;
            }
          })
          .join('');
      })
      .join('\n');
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
    const openSquares: Set<number> = new Set();
    for (const e of enemies) {
      for (const [xD, yD] of this.deltas) {
        const [x, y] = [xD + e.x, yD + e.y];
        // return if I am already adjacent to a target
        if (x == actor.x && y == actor.y) {
          return;
        }
        // If this space is open
        if (this.grid[y][x] === true) {
          openSquares.add(y * 1000 + x);
          // openSquares.push([x, y]);
        }
      }
    }
    // return if there are no adjacent squares open to a target
    if (openSquares.size == 0) {
      return;
    }

    // DFS to find reachable
    let steps = 0;
    // current point, path
    let candidates: [number, number[]][] = [[actor.y * 1000 + actor.x, []]];
    const visited: Set<number> = new Set();
    const reachable: [number, number[]][] = [];
    while (reachable.length == 0) {
      const newCandidates: [number, number[]][] = [];
      for (const [candidate, path] of candidates) {
        if (openSquares.has(candidate)) {
          reachable.push([candidate, path]);
        } else {
          const x = candidate % 1000;
          const y = Math.floor(candidate / 1000);
          for (const [xD, yD] of this.deltas) {
            const [xC, yC] = [xD + x, yD + y];
            const newCandidate = yC * 1000 + xC;
            // Open space
            if (this.grid[yC][xC] === true && !visited.has(newCandidate)) {
              visited.add(newCandidate);
              newCandidates.push([newCandidate, path.concat(newCandidate)]);
            }
          }
        }
      }
      candidates = newCandidates;
      if (candidates.length == 0 && reachable.length == 0) {
        return;
      }
      steps++;
      if (steps > 100) {
        throw `Too many Steps!!! ${steps}`;
      }
    }
    const [, path] = reachable.sort()[0];
    const nextStep = path[0];
    const x = nextStep % 1000;
    const y = Math.floor(nextStep / 1000);
    this.grid[actor.y][actor.x] = true;
    this.grid[y][x] = actor;
    actor.x = x;
    actor.y = y;
  }

  // attack(actor: Actor): void {}
  // round(): void {}
}

export { Advent };
