import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a spring of water', () => {
      expect(ad.spring).to.eql([500, 0]);
      expect(ad.grid.get(500, 0)).to.eql('+');
    });

    it('inits a sparse grid with vertical marks', () => {
      expect(ad.grid.get(495, 2)).to.eql('#');
      expect(ad.grid.get(495, 7)).to.eql('#');
      expect(ad.grid.get(1000, 1000)).to.be.undefined;
    });

    it('inits a sparse grid with horizontal marks', () => {
      expect(ad.grid.get(501, 7)).to.eql('#');
      expect(ad.grid.get(496, 7)).to.eql('#');
    });
  });

  describe('#pour', () => {
    it('pouring disturbs the sand and marks its path', () => {
      ad.pour(1);
      expect(ad.grid.get(500, 1)).to.eql('|');
      expect(ad.grid.get(500, 2)).to.eql('|');
      expect(ad.grid.get(500, 3)).to.eql('|');
    });

    it('water spreads to the left and right maximally', () => {
      ad.spring = [499, 0];
      ad.pour(4);
      expect(ad.grid.get(496, 6)).to.eql('~');
      expect(ad.grid.get(497, 6)).to.eql('~');
      expect(ad.grid.get(498, 6)).to.eql('~');
      expect(ad.grid.get(499, 6)).to.eql('|');
      expect(ad.grid.get(500, 6)).to.eql('~');
    });

    it('fills up a basin', () => {
      ad.spring = [499, 0];
      ad.pour(10);
      // console.log(ad.grid.render());
      expect(ad.grid.get(496, 6)).to.eql('~');
      expect(ad.grid.get(497, 6)).to.eql('~');
      expect(ad.grid.get(498, 6)).to.eql('~');
      expect(ad.grid.get(499, 6)).to.eql('~');
      expect(ad.grid.get(500, 6)).to.eql('~');
      expect(ad.grid.get(496, 5)).to.eql('~');
      expect(ad.grid.get(497, 5)).to.eql('~');
      expect(ad.grid.get(498, 5)).to.eql('~');
      expect(ad.grid.get(499, 5)).to.eql('~');
      expect(ad.grid.get(500, 5)).to.eql('~');
    });

    it('does not respect water pressure', () => {
      ad.pour(14);
      // console.log(ad.grid.render());
      expect(ad.grid.get(500, 4)).to.eql('~');
      expect(ad.grid.get(500, 3)).to.eql('~');
      expect(ad.grid.get(499, 3)).to.eql('~');
      expect(ad.grid.get(498, 3)).to.eql('#');
      expect(ad.grid.get(497, 3)).to.be.undefined;
    });

    xit('water flows off ledges', () => {
      ad.pour(15);
      // console.log(ad.grid.render());
      expect(ad.grid.get(499, 2)).to.eql('|');
      expect(ad.grid.get(500, 2)).to.eql('|');
      expect(ad.grid.get(501, 2)).to.eql('|');
      expect(ad.grid.get(502, 2)).to.eql('|');
      expect(ad.grid.get(502, 3)).to.eql('|');
      expect(ad.grid.get(502,12)).to.eql('~');
    });

    it('water flows off ledges equally');
  });

  describe('#pourPrime', () => {
  const expectedRender: string = `
.....+......
.....|.....#
#..#||||...#
#..#~~#|....
#..#~~#|....
#~~~~~#|....
#~~~~~#|....
#######|....
.......|....
..|||||||||.
..|#~~~~~#|.
..|#~~~~~#|.
..|#~~~~~#|.
..|#######|.
`.trim();
    it('it pours water...', () => {
      ad.pourPrime();
      // console.log(ad.grid.render());
      expect(ad.grid.render()).to.eql(expectedRender);
    });
  });

  describe('#wetTiles', () => {
    it('returns the number of wet tiles', () => {
      ad.pourPrime();
      expect(ad.wetTiles()).to.eql(57);
    });
  });
});
