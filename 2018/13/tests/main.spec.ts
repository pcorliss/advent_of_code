import { Advent, Point } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
/->-\\        
|   |  /----\\
| /-+--+-\\  |
| | |  | v  |
\\-+-/  \\-+--/
  \\------/   
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a map of carts', () => {
      expect(ad.carts).to.eql([
        [2, 0, 'e', 0],
        [9, 3, 's', 0],
      ]);
    });

    it('inits paths', () => {
      expect(ad.path[0]).to.have.length(5);
      expect(ad.path[0].join('')).to.eql('/---\\');
    });
  });

  describe('#tick', () => {
    it('moves the carts one step', () => {
      ad.tick();
      expect(ad.carts[0]).to.include.ordered.members([3, 0]);
      expect(ad.carts[1]).to.include.ordered.members([9, 4]);
    });

    it('carts turn right on corners', () => {
      ad.tick();
      ad.tick();
      expect(ad.carts[0]).to.eql([4, 0, 's', 0]);
    });

    it('carts turn left on corners', () => {
      for (let i = 0; i < 4; i++) {
        ad.tick();
      }
      expect(ad.carts[1]).to.eql([12, 4, 'n', 1]);
    });

    context('intersections', () => {
      it('carts turn left first', () => {
        ad.tick();
        expect(ad.carts[1]).to.eql([9, 4, 'e', 1]);
      });

      it('carts go straight next', () => {
        for (let i = 0; i < 7; i++) {
          ad.tick();
        }
        expect(ad.carts[0]).to.eql([7, 2, 'e', 2]);
      });

      it('carts go right next', () => {
        for (let i = 0; i < 11; i++) {
          ad.tick();
          // console.log(ad.carts);
        }
        expect(ad.carts[1]).to.eql([9, 4, 'w', 3]);
      });
    });

    it('handles cart collisions', () => {
      for (let i = 0; i < 14; i++) {
        ad.tick();
        // console.log(ad.carts);
      }
      expect(ad.collisions).to.eql([[7, 3]]);
    });
  });
});
