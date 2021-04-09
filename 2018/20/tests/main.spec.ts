import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a regex as a string', () => {
      expect(ad.pathRegex).to.eql(
        '^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$',
      );
    });

    it('inits an empty grid', () => {
      expect(ad.grid.render()).to.eql('');
    });
  });

  describe('#fill', () => {
    const expectedRender: string = `
#########
#.|.|.|.#
#-#######
#.|.|.|.#
#-#####-#
#.#.#X|.#
#-#-#####
#.|.|.|.#
#########
    `.trim();

    it('fills out the grid', () => {
      ad.fill('^ENWWW(NEEE|SSE(EE|N))$');
      expect(ad.grid.render()).to.eql(expectedRender);
    });

    const expectedRender2: string = `
###############
#.|.|.|.#.|.|.#
#-###-###-#-#-#
#.|.#.|.|.#.#.#
#-#########-#-#
#.#.|.|.|.|.#.#
#-#-#########-#
#.#.#.|X#.|.#.#
###-#-###-#-#-#
#.|.#.#.|.#.|.#
#-###-#####-###
#.|.#.|.|.#.#.#
#-#-#####-#-#-#
#.#.|.|.|.#.|.#
###############
        `.trim();

    it('fills out the grid', () => {
      ad.fill(ad.pathRegex);
      expect(ad.grid.render()).to.eql(expectedRender2);
    });

    const directionStep = {
      // '^WNE$': 3,
      // '^(EN|WS)$': 2,
      // '^N(E|W)N$': 3,
      // '^ENWWW(NEEE|SSE(EE|N))$': 10,
      // '^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$': 18,
      // '^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$': 23,
      // '^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$': 31,
    };
    for (const [inp, steps] of Object.entries(directionStep)) {
      it(`returns the max steps ${steps} required for ${inp}`, () => {
        console.log(ad.grid.render());
        expect(ad.fill(inp)).to.eql(steps);
      });
    }
  });
});
