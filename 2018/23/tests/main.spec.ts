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
});
