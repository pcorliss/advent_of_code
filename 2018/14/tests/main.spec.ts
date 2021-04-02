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
  });
});
