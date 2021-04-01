import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
initial state: #..#.#..##......###...###

...## => #
..#.. => #
.#... => #
.#.#. => #
.#.## => #
.##.. => #
.#### => #
#.#.# => #
#.### => #
##.#. => #
##.## => #
###.. => #
###.# => #
####. => #
  `.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits the plants', () => {
      expect(ad.plants.size).to.eql(11);
      expect([...ad.plants]).to.have.members([
        0,
        3,
        5,
        8,
        9,
        16,
        17,
        18,
        22,
        23,
        24,
      ]);
    });

    it('inits rules', () => {
      expect(ad.rules.size).to.eql(14);
      expect(ad.rules.get('...##')).to.eql('#');
      expect(ad.rules.get('####.')).to.eql('#');
    });
  });

  describe('#step', () => {
    it('updates the plants', () => {
      ad.step();
      expect(ad.plants.size).to.eql(7);
      expect([...ad.plants]).to.have.members([0, 4, 9, 15, 18, 21, 24]);
    });

    it('handles negative and expanding bounds', () => {
      ad.step();
      ad.step();
      ad.step();
      expect(ad.plants.size).to.eql(9);
      expect(ad.plants).to.include(-1);
      expect(ad.plants).to.include(25);
    });
  });

  describe('verification', () => {
    it('finds the correct sum for the plant array after 20 steps', () => {
      for (let i = 0; i < 20; i++) {
        ad.step();
      }
      const sum = [...ad.plants].reduce((sum, i) => sum + i, 0);
      expect(sum).to.eql(325);
    });
  });
});
