import Advent from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of dependencies', () => {
      expect(ad.dependencies.get('A')).to.eql(['C']);
      expect(ad.dependencies.get('E')).to.eql(['B', 'D', 'F']);
      expect(ad.dependencies.get('C')).to.eql(undefined);
    });

    it('inits a list of reverse dependencies', () => {
      expect(ad.reverseDep.get('A')).to.eql(['B', 'D']);
      expect(ad.reverseDep.get('E')).to.eql(undefined);
      expect(ad.reverseDep.get('C')).to.eql(['A', 'F']);
    });

    it('inits a list of steps', () => {
      expect(ad.steps).to.include('E');
      expect(ad.steps).to.include('C');
    });

    it('inits a stepLength', () => {
      expect(ad.stepLength).to.eql(6);
    });
  });

  describe('#calcOrder', () => {
    it('returns the first step', () => {
      expect(ad.calcOrder()[0]).to.eql('C');
    });

    it('returns the next in the chain alphabetically', () => {
      expect(ad.calcOrder()[1]).to.eql('A');
    });

    it('continues to populate the chain alphabetically', () => {
      expect(ad.calcOrder()[2]).to.eql('B');
      expect(ad.calcOrder()[3]).to.eql('D');
    });

    it('takes into account whether dependencies have been satisfied', () => {
      expect(ad.calcOrder()[4]).to.eql('F');
      expect(ad.calcOrder()[5]).to.eql('E');
    });

    it('handles multiple potential starts', () => {
      const inp: string = `
Step Z must be finished before step W can begin.
Step Z must be finished before step X can begin.
Step Y must be finished before step X can begin.
Step Y must be finished before step W can begin.
Step A must be finished before step Y can begin.
      `.trim();
      ad = new Advent(inp);
      expect(ad.calcOrder()).to.eql(['A', 'Y', 'Z', 'W', 'X']);
    });
  });
});
