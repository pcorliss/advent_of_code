import Advent from '../src/main';
import { expect } from 'chai';
import 'mocha';

describe('Advent', () => {
  const input: string = `
abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of boxes', () => {
      expect(ad.boxes).to.have.lengthOf(7);
      expect(ad.boxes[0]).to.eql('abcdef');
    });
  });

  describe('#charCount', () => {
    it('returns a map when there is one instance of repeated letters', () => {
      const expectedMap = new Map<string, number>([
        ['a', 3],
        ['b', 2],
        ['c', 1],
      ]);
      expect(ad.charCount('aaabbc')).to.eql(expectedMap);
    });
  });

  describe('#checksum', () => {
    it('returns count of triplets and doubles per boxId multiplied', () => {
      expect(ad.checksum()).to.eql(12);
    });
  });
});
