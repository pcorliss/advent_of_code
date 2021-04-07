import { Advent } from '../src/main';
import { expect } from 'chai';
import fs = require('fs');

describe('Advent', () => {
  const input: string = `
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a sparse grid', () => {
      expect(ad.grid.get(0, 0)).to.be.undefined;
      expect(ad.grid.get(1, 0)).to.eql('#');
      expect(ad.grid.get(1, 2)).to.eql('|');
    });

    it('inits bounds', () => {
      expect(ad.bounds).to.eql([
        [0, 0],
        [9, 9],
      ]);
    });
  });

  describe('#step', () => {
    it('An open acre will become filled with trees if three or more adjacent acres contained trees.', () => {
      expect(ad.grid.get(4, 3)).to.be.undefined;
      ad.step();
      expect(ad.grid.get(4, 3)).to.eql('|');
    });

    it('An open acre will will do nothing if there are two or fewer trees', () => {
      expect(ad.grid.get(0, 0)).to.be.undefined;
      ad.step();
      expect(ad.grid.get(0, 0)).to.be.undefined;
    });

    it('An acre filled with trees will become a lumberyard if three or more adjacent acres were lumberyards.', () => {
      expect(ad.grid.get(9, 1)).to.eql('|');
      ad.step();
      expect(ad.grid.get(9, 1)).to.eql('#');
    });

    it('An acre filled with trees will do nothing if there are two or fewer lumberyards', () => {
      expect(ad.grid.get(6, 1)).to.eql('|');
      expect(ad.grid.get(2, 3)).to.eql('|');
      ad.step();
      expect(ad.grid.get(6, 1)).to.eql('|');
      expect(ad.grid.get(2, 3)).to.eql('|');
    });

    it('An acre containing a lumberyard will remain a lumberyard if it was adjacent to at least one other lumberyard and at least one acre containing trees.', () => {
      expect(ad.grid.get(8, 0)).to.eql('#');
      ad.step();
      expect(ad.grid.get(8, 0)).to.eql('#');
    });

    it('An acre containing a lumberyard becomes open.', () => {
      expect(ad.grid.get(1, 0)).to.eql('#');
      ad.step();
      expect(ad.grid.get(1, 0)).to.be.undefined;
    });

    it('renders correctly', () => {
      const expected: string = `
.......##.
......|###
.|..|...#.
..|#||...#
..##||.|#|
...#||||..
||...|||..
|||||.||.|
||||||||||
....||..|.
`.trim();
      ad.step();
      expect(ad.grid.render()).to.eql(expected);
    });

    it('renders correctly after multiple steps', () => {
      const expected: string = `
.||##.....
||###.....
||##......
|##.....##
|##.....##
|##....##|
||##.####|
||#####|||
||||#|||||
||||||||||
      `.trim();
      for (let i = 0; i < 10; i++) {
        ad.step();
      }
      expect(ad.grid.render()).to.eql(expected);
    });
  });

  describe('#valCount', () => {
    it('returns a count of trees and lumberyards', () => {
      for (let i = 0; i < 10; i++) {
        ad.step();
      }
      expect(ad.valueCount().get('|')).to.eql(37);
      expect(ad.valueCount().get('#')).to.eql(31);
    });
  });

  describe('#findWithCycle', () => {
    const input_str: string = fs.readFileSync('spec_input.txt', 'utf8');

    beforeEach(() => {
      ad = new Advent(input_str);
    });

    it('returns the value at a particular step count', () => {
      expect(ad.findWithCycle(1000)).to.eql(233020);
    });
  });
});
