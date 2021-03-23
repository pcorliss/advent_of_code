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
    // it('inits a list of sorted events', () => {
    //   expect(ad.guardEvents).to.have.lengthOf(17);
    //   const [dt, action] = ad.guardEvents.entries().next()['value'];
    //   expect(dt).to.eql(new Date('1518-11-01 00:00'));
    //   expect(action).to.eql('Guard #10 begins shift');
    // });
  });
});
