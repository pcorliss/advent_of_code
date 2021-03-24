import Advent from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9  
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of points', () => {
      expect(ad.points).to.have.lengthOf(6);
      expect(ad.points[0]).to.eql([1, 1]);
    });
  });

  describe('#boundingBox', () => {
    it('returns max x,y and min x,y', () => {
      expect(ad.boundingBox()).to.eql([
        [1, 1],
        [8, 9],
      ]);
    });
  });

  describe('#centerPoint', () => {
    it('returns centerPoint of box', () => {
      expect(ad.centerPoint()).to.eql([4, 5]);
    });
  });

  describe('#gridCalc', () => {
    it('takes an integer and returns the updated count of neighbors', () => {
      expect(ad.gridCalc(0).get(3)).to.eql(9);
      expect(ad.gridCalc(0).get(4)).to.eql(17);
    });
    it('handles an expanding bounding box', () => {
      expect(ad.gridCalc(1).get(0)).to.eql(15);
    });
  });

  describe('#nearestPoint', () => {
    it('returns nearestPoint of a defined point', () => {
      expect(ad.nearestPoint(3, 4)).to.eql(3);
    });
    it('returns nearestPoint of a nearby point', () => {
      expect(ad.nearestPoint(4, 4)).to.eql(3);
    });
    it('returns null of a equidistant point', () => {
      expect(ad.nearestPoint(2, 5)).to.eql(null);
    });
  });

  describe('#findNonInfinitePoints', () => {
    it('returns all non-infinite points', () => {
      expect(ad.findNonInfinitePoints()).to.eql([3, 4]);
    });
  });

  describe('#largestNonInfiniteArea', () => {
    it('returns all non-infinite points', () => {
      expect(ad.largestNonInfiniteArea()).to.eql(17);
    });
  });

  describe('#sumDistance', () => {
    it('returns the sum of all distances to particular point', () => {
      expect(ad.sumDistance(4, 3)).to.eql(30);
    });
  });

  describe('#safeArea', () => {
    it('returns the safe cells with sumDistance of less than passed value', () => {
      expect(ad.safeArea(32)).to.eql(16);
    });
  });
});
