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

  move(actor: Actor, debug = false): void {
    // identifying all possible targets
    const enemies = this.actors.filter((a) => a.t != actor.t && a.hp > 0);
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

  attack(actor: Actor): void {
    const nearbyEnemies: Actor[] = [];
    for (const [xD, yD] of this.deltas) {
      const [x, y] = [xD + actor.x, yD + actor.y];
      const square = this.grid[y][x];
      if (typeof square != 'boolean' && square.t != actor.t) {
        nearbyEnemies.push(square);
      }
    }
    nearbyEnemies.sort((a, b) => a.hp - b.hp);
    if (nearbyEnemies.length > 0) {
      nearbyEnemies[0].hp -= 3;
      if (nearbyEnemies[0].hp <= 0) {
        // const idx = this.actors.indexOf(nearbyEnemies[0]);
        // this.actors.splice(idx,1);
        this.grid[nearbyEnemies[0].y][nearbyEnemies[0].x] = true;
      }
    }
  }
  round(debug = false): boolean {
    this.actors.sort((a, b) => a.y * 1000 + a.x - (b.y * 1000 + b.x));
    for (const actor of this.actors) {
      // const showDebug = debug && actor.x == 5 && actor.y == 2;
      if (actor.hp > 0) {
        // Weird requirement where we only stop if an actor
        // notices there are no more enemies
        const actorTypes: Set<string> = new Set(
          this.actors.filter((a) => a.hp > 0).map((a) => a.t),
        );
        if (actorTypes.size <= 1) {
          return false;
        }
        // if (showDebug) { console.log("Working ON: ", actor) }
        this.move(actor);
        // if (showDebug) { console.log(this.render()) }
        // if (showDebug) { console.log(this.actors) }
        this.attack(actor);
        // if (showDebug) { console.log(this.render()) }
        // if (showDebug) { console.log(this.actors) }
      }
    }

    // console.log('Actor Types:', actorTypes);
    // console.log('Actors: ', this.actors);
    return true; // actorTypes.size > 1;
  }

  runUntilFinished(): number {
    let steps = 0;
    while (this.round()) {
      steps++;
    }
    const hp = this.actors
      .filter((a) => a.hp > 0)
      .reduce((acc, a) => (acc += a.hp), 0);
    // console.log(`Steps: ${steps}, HP: ${hp}`);
    return steps * hp;
  }
}

export { Advent };
