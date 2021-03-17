import Advent from '../src/main';
import { expect } from 'chai';
import 'mocha';

describe('Advent', () => {
  const input: string = `
+1
-2
+3
+1
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of frequencies', () => {
      expect(ad.frequencies).to.eql([1, -2, 3, 1]);
    });
  });

  describe('#frequency', () => {
    it('returns the sum of frequencies', () => {
      expect(ad.frequency()).to.eql(3);
    });
  });

  describe('#first_dupe', () => {
    it('returns the first frequency it sees twice', () => {
      expect(ad.first_dupe()).to.eql(2);
    });
  });
});
