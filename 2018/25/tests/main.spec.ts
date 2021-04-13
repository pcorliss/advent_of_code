import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
0,0,0,0
3,0,0,0
0,3,0,0
0,0,3,0
0,0,0,3
0,0,0,6
9,0,0,0
12,0,0,0
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits points', () => {
      expect(ad.points).to.have.lengthOf(8);
      expect(ad.points[0]).to.eql([0, 0, 0, 0]);
    });
  });

  describe('#adjacent', () => {
    it('returns false', () => {
      expect(ad.adjacent([0, 0, 0, 0], [0, 0, 0, 4])).to.be.false;
    });

    it('returns true if close by manhattan of 3 or less', () => {
      expect(ad.adjacent([0, 0, 0, 0], [0, 1, 1, 1])).to.be.true;
    });
  });

  describe('#formConstellations', () => {
    it('returns two constellations', () => {
      // console.log('Constellations: ', ad.formConstellations());
      expect(ad.formConstellations()).to.have.lengthOf(2);
      expect(ad.formConstellations()[1]).to.have.lengthOf(6);
      expect(ad.formConstellations()[0]).to.have.lengthOf(2);
    });

    it('joins larger constellations if the right point is present', () => {
      ad.points.push([6, 0, 0, 0]);
      expect(ad.formConstellations()).to.have.lengthOf(1);
    });

    const input4 = `
    -1,2,2,0
    0,0,2,-2
    0,0,0,-2
    -1,2,0,0
    -2,-2,-2,2
    3,0,2,-1
    -1,3,2,2
    -1,0,-1,0
    0,2,1,-2
    3,0,0,0
    `.trim();

    const input3 = `
1,-1,0,1
2,0,-1,0
3,2,-1,0
0,0,3,1
0,0,-1,-1
2,3,-2,0
-2,2,0,0
2,-2,0,-1
1,-1,0,-1
3,2,0,2
    `.trim();

    const input8 = `
1,-1,-1,-2
-2,-2,0,1
0,2,1,3
-2,3,-2,1
0,2,3,-2
-1,-1,1,-2
0,-2,-1,0
-2,2,3,-1
1,2,2,0
-1,-2,0,-2
    `.trim();

    it('yields correct constllation amounts for various inputs', () => {
      ad = new Advent(input4);
      expect(ad.formConstellations()).to.have.lengthOf(4);
      ad = new Advent(input3);
      expect(ad.formConstellations()).to.have.lengthOf(3);
      ad = new Advent(input8);
      expect(ad.formConstellations()).to.have.lengthOf(8);
    });
  });
});
