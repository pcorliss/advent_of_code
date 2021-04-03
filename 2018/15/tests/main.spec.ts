import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a battle field as a grid with [y][x] coords', () => {
      expect(ad.grid[0][0]).to.eql(false);
      expect(ad.grid[1][1]).to.eql(true);
      expect(ad.grid[6][6]).to.eql(false);
    });

    it('inits a battle field with actor references', () => {
      expect(ad.grid[1][2].t).to.eql('G');
      expect(ad.grid[2][4].t).to.eql('E');
    });

    it('inits actors', () => {
      expect(ad.actors).to.have.lengthOf(6);
      expect(ad.actors[0]).to.eql({
        x: 2,
        y: 1,
        hp: 200,
        t: 'G',
        elf: false,
        goblin: true,
      });
    });
  });

  describe('#move', () => {
    it('does not move if it is in attack range', () => {
      const elf = ad.actors[1];
      expect(elf.elf).to.be.true;
      ad.move(elf);
      expect(elf.x).to.eql(4);
      expect(elf.y).to.eql(2);
    });

    it('moves horizontally until next to an enemy', () => {
      const gob = ad.actors[0];
      expect(gob.goblin).to.be.true;
      expect(gob.x).to.eql(2);
      expect(gob.y).to.eql(1);
      ad.move(gob);
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(1);
      ad.move(gob);
      expect(gob.x).to.eql(4);
      expect(gob.y).to.eql(1);
      ad.move(gob);
      expect(gob.x).to.eql(4);
      expect(gob.y).to.eql(1);
    });

    it('moves vertically until next to an enemy', () => {
      const gob = ad.actors[4];
      expect(gob.goblin).to.be.true;
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(4);
      ad.move(gob);
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(3);
      ad.move(gob);
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(2);
      ad.move(gob);
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(2);
    });

    it('updates the grid with their movements', () => {
      const gob = ad.actors[0];
      expect(ad.grid[1][2]).to.eql(gob);
      ad.move(gob);
      expect(ad.grid[1][3]).to.eql(gob);
      expect(ad.grid[1][2]).to.eql(true);
    });

    context('verification', () => {
      const roundResults: string[] = [
        `
#########
#G..G..G#
#.......#
#.......#
#G..E..G#
#.......#
#.......#
#G..G..G#
#########
`.trim(),
        `
#########
#.G...G.#
#...G...#
#...E..G#
#.G.....#
#.......#
#G..G..G#
#.......#
#########
`.trim(),
        `
#########
#..G.G..#
#...G...#
#.G.E.G.#
#.......#
#G..G..G#
#.......#
#.......#
#########
`.trim(),
        `
#########
#.......#
#..GGG..#
#..GEG..#
#G..G...#
#......G#
#.......#
#.......#
#########
`.trim(),
        `
#########
#.......#
#..GGG..#
#..GEG..#
#G..G...#
#......G#
#.......#
#.......#
#########
`.trim(),
      ];

      beforeEach(() => {
        ad = new Advent(roundResults[0]);
      });

      it('yields the right result for no movement/initial state', () => {
        expect(ad.render()).to.eql(roundResults[0]);
      });

      for (const [idx, expected] of roundResults.entries()) {
        it(`yields the expected result for ${idx} steps`, () => {
          for (let i = 0; i < idx; i++) {
            for (const actor of ad.actors) {
              ad.move(actor);
            }
          }
          expect(ad.render()).to.eql(expected);
        });
      }
    });
  });

  describe('#attack', () => {
    it('does nothing if there is not an adjacent enemy', () => {
      const gob = ad.actors[0];
      ad.attack(gob);
      expect(ad.actors.map((a) => a.hp)).to.eql([200, 200, 200, 200, 200, 200]);
    });

    it('reduces hp by 3 of an enemy', () => {
      const elf = ad.actors[1];
      const gob = ad.actors[2];
      ad.attack(elf);
      expect(gob.hp).to.eql(197);
    });

    it('selects a unit based on who has the fewest hp', () => {
      const elf = ad.actors[1];
      const gob1 = ad.actors[2];
      const gob2 = ad.actors[0];
      gob2.hp = 4;
      ad.move(gob2);
      ad.move(gob2);
      ad.attack(elf);
      expect(gob1.hp).to.eql(200);
      expect(gob2.hp).to.eql(1);
    });

    it('selects a unit based on reading order if hp is the same', () => {
      const elf = ad.actors[1];
      const gob1 = ad.actors[2];
      const gob2 = ad.actors[0];
      ad.move(gob2);
      ad.move(gob2);
      ad.attack(elf);
      expect(gob1.hp).to.eql(200);
      expect(gob2.hp).to.eql(197);
    });

    it('removes an actor from the grid if it runs out of hp', () => {
      const elf = ad.actors[1];
      const gob = ad.actors[2];
      for (let i = 0; i < 68; i++) {
        ad.attack(elf);
      }
      expect(ad.grid[gob.y][gob.x]).to.eql(true);
    });
  });

  describe('#round', () => {
    it('does not process dead actors', () => {
      const elf = ad.actors[1];
      const gob = ad.actors[2];
      gob.hp = 1;
      ad.round();
      expect(elf.hp).to.eql(200);
    });

    it('applies movement', () => {
      const gob = ad.actors[0];
      ad.round();
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(1);
    });

    it('applies attack', () => {
      const elf = ad.actors[1];
      ad.round();
      expect(elf.hp).to.eql(197);
    });

    it('returns true', () => {
      expect(ad.round()).to.eql(true);
    });

    it('returns false if the round was not completed because there were no more enemies', () => {
      const elf1 = ad.actors[1];
      const elf2 = ad.actors[5];
      elf1.hp = 1;
      elf2.hp = 1;
      expect(ad.round()).to.eql(false);
    });

    context('verification', () => {
      const roundIdx = [0, 1, 2, 23, 24, 25, 26, 27, 28, 47];
      const lowHp = [200, 197, 188, 131, 128, 125, 122, 119, 113, 59];
      const roundResults = [
        `
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
`.trim(),
        `
#######
#..G..#
#...EG#
#.#G#G#
#...#E#
#.....#
#######
`.trim(),
        `
#######
#...G.#
#..GEG#
#.#.#G#
#...#E#
#.....#
#######
`.trim(),
        `
#######
#...G.#
#..G.G#
#.#.#G#
#...#E#
#.....#
#######
`.trim(),
        `
#######
#..G..#
#...G.#
#.#G#G#
#...#E#
#.....#
#######
`.trim(),
        `
#######
#.G...#
#..G..#
#.#.#G#
#..G#E#
#.....#
#######
`.trim(),
        `
#######
#G....#
#.G...#
#.#.#G#
#...#E#
#..G..#
#######
`.trim(),
        `
#######
#G....#
#.G...#
#.#.#G#
#...#E#
#...G.#
#######
`.trim(),
        `
#######
#G....#
#.G...#
#.#.#G#
#...#E#
#....G#
#######
`.trim(),
        `
#######
#G....#
#.G...#
#.#.#G#
#...#.#
#....G#
#######
`.trim(),
      ];
      beforeEach(() => {
        ad = new Advent(roundResults[0]);
      });

      for (const [idx, steps] of roundIdx.entries()) {
        it(`yields the expected result for ${steps} steps`, () => {
          for (let i = 0; i < steps; i++) {
            ad.round();
          }
          // console.log(ad.render());
          // console.log(ad.actors);
          expect(ad.render()).to.eql(roundResults[idx]);
          expect(ad.actors.map((a) => a.hp)).to.include(lowHp[idx]);
        });
      }

      it('returns false on the 48th step', () => {
        for (let i = 0; i < 45; i++) {
          ad.round();
        }
        expect(ad.round()).to.eql(true); // 46
        expect(ad.round()).to.eql(true); // 47
        expect(ad.round()).to.eql(false); // 48
      });

      it('handles an ordering bug', () => {
        // Need to ensure that each unit takes it's turn in readability order y then x
        for (let i = 0; i < 23; i++) {
          ad.round();
        }
        ad.round();
        // console.log(ad.render());
        // console.log(ad.actors);
        expect(ad.render()).to.eql(roundResults[4]);
      });
    });

    describe('#runUntilFinished', () => {
      it('#returns the score for a sample game', () => {
        expect(ad.runUntilFinished()).to.eql(27730);
      });

      context('verification', () => {
        const scores = [36334, 39514, 27755, 28944, 18740];
        const roundInit = [
          `
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
`.trim(),
          `
#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######
`.trim(),
          `
#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######
`.trim(),
          `
#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######
`.trim(),
          `
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
`.trim(),
        ];
        const roundResults = [
          `
#######
#...#E#
#E#...#
#.E##.#
#E..#E#
#.....#
#######
`.trim(),
          `
#######
#.E.E.#
#.#E..#
#E.##.#
#.E.#.#
#...#.#
#######
`.trim(),
          `
#######
#G.G#.#
#.#G..#
#..#..#
#...#G#
#...G.#
#######
`.trim(),
          `
#######
#.....#
#.#G..#
#.###.#
#.#.#.#
#G.G#G#
#######
`.trim(),
          `
#########
#.G.....#
#G.G#...#
#.G##...#
#...##..#
#.G.#...#
#.......#
#.......#
#########
`.trim(),
        ];
        for (const [idx, score] of scores.entries()) {
          it(`yields the expected result for ${idx}`, () => {
            ad = new Advent(roundInit[idx]);
            expect(ad.runUntilFinished()).to.eql(score);
            expect(ad.render()).to.eql(roundResults[idx]);
            // console.log(ad.render());
            // console.log(ad.actors);
          });
        }
      });
    });
  });

  // the order in which units take their turns within a round is the reading order of their starting positions in that round
  // If no targets remain, combat ends.
});
