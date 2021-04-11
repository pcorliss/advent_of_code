import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
depth: 510
target: 10,10
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits an empty grid', () => {
      expect(ad.grid.map.size).to.eql(0);
    });

    it('inits the depth', () => {
      expect(ad.depth).to.eql(510);
    });

    it('inits an origin', () => {
      expect(ad.origin).to.eql([0, 0]);
    });

    it('inits a target', () => {
      expect(ad.target).to.eql([10, 10]);
    });
  });

  describe('#geologic', () => {
    it('The region at 0,0 (the mouth of the cave) has a geologic index of 0.', () => {
      expect(ad.geologic(0, 0)).to.eql(0);
    });

    it('The region at the coordinates of the target has a geologic index of 0.', () => {
      expect(ad.geologic(10, 10)).to.eql(0);
    });

    it("If the region's Y coordinate is 0, the geologic index is its X coordinate times 16807.", () => {
      expect(ad.geologic(2, 0)).to.eql(2 * 16807);
    });

    it("If the region's X coordinate is 0, the geologic index is its Y coordinate times 48271.", () => {
      expect(ad.geologic(0, 2)).to.eql(2 * 48271);
    });

    it("Otherwise, the region's geologic index is the result of multiplying the erosion levels of the regions at X-1,Y and X,Y-1.", () => {
      expect(ad.geologic(1, 1)).to.eql(8415 * 17317);
      expect(ad.geologic(1, 1)).to.eql(145722555);
    });

    it('does not get into an infinite loop if the numbers are negative', () => {
      expect(ad.geologic(-1, -1)).to.eql(0);
    });
  });

  describe('#erosion', () => {
    it("A region's erosion level is its geologic index plus the cave system's depth, all modulo 20183.", () => {
      expect(ad.erosion(1, 1)).to.eql(1805);
    });
  });

  describe('#conditionLevel', () => {
    // A region's erosion level is its geologic index plus the cave system's depth, all modulo 20183
    it('If the erosion level modulo 3 is 0.', () => {
      expect(ad.conditionLevel(0, 1)).to.eql(0);
    });

    it('If the erosion level modulo 3 is 1.', () => {
      expect(ad.conditionLevel(1, 0)).to.eql(1);
    });

    it('If the erosion level modulo 3 is 2.', () => {
      expect(ad.conditionLevel(1, 1)).to.eql(2);
    });
  });

  describe('#condition', () => {
    it("If the erosion level modulo 3 is 0, the region's type is rocky.", () => {
      expect(ad.condition(0, 1)).to.eql('.');
    });

    it("If the erosion level modulo 3 is 1, the region's type is wet.", () => {
      expect(ad.condition(1, 0)).to.eql('=');
    });

    it("If the erosion level modulo 3 is 2, the region's type is narrow.", () => {
      expect(ad.condition(1, 1)).to.eql('|');
    });
  });

  describe('#risk', () => {
    it('returns the condition level sum between origin and target', () => {
      expect(ad.risk()).to.eql(114);
    });
  });
});
