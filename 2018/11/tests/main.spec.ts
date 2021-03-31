import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
8
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a grid serial number', () => {
      expect(ad.serial).to.eql(8);
    });

    it('inits an empty grid', () => {
      expect(ad.grid).to.eql([]);
    });
  });

  describe('#powerLevel', () => {
    it('returns the power level of a specific coordinate', () => {
      expect(ad.powerLevel(3, 5)).to.eql(4);
    });

    it('caches the power level', () => {
      ad.powerLevel(3, 5);
      expect(ad.grid[3][5]).to.eql(4);
    });

    context('verification', () => {
      const a = [
        [122, 79, 57, -5],
        [217, 196, 39, 0],
        [101, 153, 71, 4],
      ];

      for (const [x, y, serial, expected] of a) {
        it(`yields the correct powerLevel ${expected} for ${x},${y} and serial ${serial}`, () => {
          ad = new Advent(`${serial}`);
          expect(ad.powerLevel(x, y)).to.eql(expected);
        });
      }
    });
  });

  context('serial18', () => {
    beforeEach(() => {
      const serial = 18;
      ad = new Advent(serial.toString());
    });

    describe('#blockPowerLevel', () => {
      it('returns the combined power of a 3x3 block', () => {
        expect(ad.blockPowerLevel(33, 45)).to.eql(29);
      });

      it('accepts a size parameter', () => {
        expect(ad.blockPowerLevel(90, 269, 16)).to.eql(113);
      });
    });

    describe('#largestBlock', () => {
      it('returns the coordinates of the largest block', () => {
        expect(ad.largestBlock()).to.eql([33, 45, 3]);
      });

      it('accepts a size range', () => {
        expect(ad.largestBlock(1, 20)).to.eql([90, 269, 16]);
      });
    });
  });
});
