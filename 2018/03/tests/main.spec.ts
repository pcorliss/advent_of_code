import Advent from '../src/main';
import { expect } from 'chai';
import 'mocha';

describe('Advent', () => {
  const input: string = `
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of claims', () => {
      expect(ad.claims).to.have.lengthOf(3);
      expect(ad.claims[0]).to.eql([1, 3, 4, 4]);
    });

    it('inits a 1000x1000 grid', () => {
      expect(ad.grid).to.be.a('array');
      expect(ad.grid).to.have.lengthOf(1000);
      expect(ad.grid[0]).to.have.lengthOf(1000);
      expect(ad.grid[0][0]).to.be.empty;
    });
  });

  describe('#fillGrid', () => {
    beforeEach(() => {
      ad.fillGrid();
    });

    it('populates the grid squares', () => {
      expect(ad.grid[3][3]).to.eql([1, 2]);
      expect(ad.grid[4][4]).to.eql([1, 2]);
      expect(ad.grid[5][4]).to.eql([2]);
      expect(ad.grid[5][5]).to.eql([3]);
    });
  });

  describe('#overlapCount', () => {
    beforeEach(() => {
      ad.fillGrid();
    });

    it('returns the number of squares that overlap', () => {
      expect(ad.overlapCount()).to.eql(4);
    });
  });

  describe('#noOverlaps', () => {
    beforeEach(() => {
      ad.fillGrid();
    });

    it('returns the id of the pattern that doesnt overlap', () => {
      expect(ad.noOverlaps()).to.eql(3);
    });
  });
});
