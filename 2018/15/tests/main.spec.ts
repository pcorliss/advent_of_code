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

  // the order in which units take their turns within a round is the reading order of their starting positions in that round
  // If no targets remain, combat ends.
});
