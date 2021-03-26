import Advent from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of dependencies', () => {
    //   expect(ad.dependencies.get('A')).to.eql(['C']);
    //   expect(ad.dependencies.get('E')).to.eql(['B', 'D', 'F']);
    //   expect(ad.dependencies.get('C')).to.eql(undefined);
    });
  });
});
