import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
9
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a number of recipies', () => {
      expect(ad.numRecipies).to.eql(9);
    });

    it('inits a list of scores', () => {
      expect(ad.scores).to.eql([3, 7]);
    });

    it('inits elf positions', () => {
      expect(ad.elves).to.eql([0, 1]);
    });
  });

  describe('#create', () => {
    it('creates new recipies based on the sum', () => {
      expect(ad.create()).to.eql([1, 0]);
    });

    it('adds the new recipies to the end of the scores', () => {
      ad.create();
      expect(ad.scores).to.eql([3, 7, 1, 0]);
    });

    it('elves step forward 1 + the number of their recipie, and back to their origin', () => {
      ad.create();
      expect(ad.elves).to.eql([0, 1]);
    });

    it('elves step forward to new locations after two creates', () => {
      ad.create();
      ad.create();
      expect(ad.elves).to.eql([4, 3]);
    });
  });

  describe('#indexOfSubArray', () => {
    it('returns the index of a subArray', () => {
      ad.scores = [1, 2, 3, 4, 5, 6];
      expect(ad.indexOfSubArray([3, 4, 5, 6])).to.eql(2);
    });

    it("returns the index of things that aren't at the end either", () => {
      ad.scores = [1, 2, 3, 4, 5, 6];
      expect(ad.indexOfSubArray([3, 4, 5])).to.eql(2);
    });

    it("returns -1 for things that aren't at the end of the array", () => {
      ad.scores = [1, 2, 3, 4, 5, 6];
      expect(ad.indexOfSubArray([2, 3])).to.eql(-1);
    });
  });

  describe('#createUntil', () => {
    it('returns the number of steps until a list of numbers appears', () => {
      expect(ad.createUntil([0, 1, 2, 4, 5])).to.eql(5);
    });
  });

  context('verification', () => {
    const cases: [number, string][] = [
      [9, '5158916779'],
      [5, '0124515891'],
      [18, '9251071085'],
      [2018, '5941429882'],
    ];
    for (const [creates, expected] of cases) {
      it(`yields ${expected} when running ${creates} creates`, () => {
        while (ad.scores.length < creates + 10) {
          ad.create();
        }
        // console.log(`Scores: ${ad.scores.join(' ')}`);
        // console.log(`Scores: ${ad.scores.slice(-10).join('')}`);
        expect(ad.scores.slice(creates, creates + 10).join('')).to.eql(
          expected,
        );
      });
    }

    const createUntilCases: [number, number[]][] = [
      [9, [5, 1, 5, 8, 9]],
      [5, [0, 1, 2, 4, 5]],
      [18, [9, 2, 5, 1, 0]],
      [2018, [5, 9, 4, 1, 4]],
    ];
    for (const [expected, subArr] of createUntilCases) {
      it(`yields ${expected} when looking for ${subArr}`, () => {
        expect(ad.createUntil(subArr)).to.eql(expected);
      });
    }
  });
});
