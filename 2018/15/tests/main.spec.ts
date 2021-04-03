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

    it('moves one step', () => {
      const gob = ad.actors[0];
      expect(gob.goblin).to.be.true;
      ad.move(gob);
      expect(gob.x).to.eql(3);
      expect(gob.y).to.eql(2);
    });
  });

  // the order in which units take their turns within a round is the reading order of their starting positions in that round
  // If no targets remain, combat ends.
});
