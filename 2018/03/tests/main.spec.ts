import Advent from '../src/main';
import { expect } from 'chai';
import 'mocha';

describe('Advent', () => {
  const input: string = `
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    // it('inits a list of boxes', () => {
    //   expect(ad.boxes).to.have.lengthOf(7);
    //   expect(ad.boxes[0]).to.eql('abcdef');
    // });
  });

});
