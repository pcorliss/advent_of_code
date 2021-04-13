import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a 3D grid', () => {
      expect(ad.grid.map.size).to.eql(9);
      expect(ad.grid.get(0, 0, 0)).to.eql(4);
    });
  });

  describe('#strongestBot', () => {
    it('returns the bot with the biggest range', () => {
      expect(ad.strongestBot()).to.eql([0, 0, 0, 4]);
    });
  });

  describe('#inRange', () => {
    it('returns itself', () => {
      expect(ad.inRange(...ad.strongestBot())).to.deep.include([0, 0, 0, 4]);
    });

    it('returns others', () => {
      expect(ad.inRange(...ad.strongestBot())).to.have.lengthOf(7);
    });
  });

  describe('#cubeIntersections', () => {
    it('returns the number of bots in the cube', () => {
      expect(ad.cubeIntersections(0, 0, 0, 5)).to.eql(9);
    });

    it('returns the number of bots that intersect with the cube', () => {
      expect(ad.cubeIntersections(-1, -1, -2, 1)).to.eql(1);
    });

    it('returns zero for a cube with no intersections', () => {
      expect(ad.cubeIntersections(-10, -10, -10, 5)).to.eql(0);
    });
  });

  describe('#octoChop', () => {
    it('returns 8 cubes from a single cube', () => {
      expect(ad.octoChop(0, 0, 0, 10)).to.have.lengthOf(8);
      expect(ad.octoChop(0, 0, 0, 10)).to.deep.include([0, 0, 0, 5]);
      expect(ad.octoChop(0, 0, 0, 10)).to.deep.include([5, 0, 0, 5]);
    });

    // it('handles odd numbers for d', () => {
    //   expect(ad.octoChop(0, 0, 0, 5)).to.have.lengthOf(8);
    //   console.log(ad.octoChop(0,0,0,5));
    //   expect(ad.octoChop(0,0,0,5)).to.deep.include([0,0,0,3]);
    //   expect(ad.octoChop(0,0,0,5)).to.deep.include([3,0,0,2]);
    // });
  });

  describe('#solver', () => {
    const solverInput: string = `
pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
`.trim();

    beforeEach(() => {
      ad = new Advent(solverInput);
    });

    it('returns', () => {
      expect(ad.solver()).to.eql([12, 12, 12, 5]);
    });
    describe('#scoreTinyCube', () => {
      it('returns a score of 5 for 12,12,12', () => {
        expect(ad.scoreTinyCube(12, 12, 12)).to.eql([12, 12, 12, 5]);
        expect(ad.scoreTinyCube(11, 11, 11)).to.eql([12, 12, 12, 5]);
      });

      it('returns the cube closest to the origin');
    });
  });
});
