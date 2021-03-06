import Advent from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `dabAcCaCBAcCcaDA
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a polymer chain', () => {
      expect(ad.polymer).to.eql('dabAcCaCBAcCcaDA');
    });
  });

  describe('#reduce', () => {
    it('reduces a polymer from left to right as many steps as possible', () => {
      expect(ad.reduce('dabAcCaCBAcCcaDA')).to.eql('dabCBAcaDA');
      expect(ad.reduce('dabAaCBAcCcaDA')).to.eql('dabCBAcaDA');
      expect(ad.reduce('dabCBAcCcaDA')).to.eql('dabCBAcaDA');
    });

    it("doesn't change the string if there's no reducing possible", () => {
      expect(ad.reduce('dabCBAcaDA')).to.eql('dabCBAcaDA');
      expect(ad.reduce('dabCBAcaDA')).to.have.lengthOf(10);
    });
  });

  describe('#reduceAll', () => {
    it('reduces a polymer the maximum number of times', () => {
      expect(ad.reduceAll('dabAcCaCBAcCcaDA')).to.eql('dabCBAcaDA');
      expect(ad.reduce('dabCBAcaDA')).to.have.lengthOf(10);
    });
  });

  describe('#optimisePoly', () => {
    it('removes problematic char pairs from polymers and finds the optimized one', () => {
      expect(ad.optimizePoly('dabAcCaCBAcCcaDA')).to.eql('daDA');
    });
  });
});
