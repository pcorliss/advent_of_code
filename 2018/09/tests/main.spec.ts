import { Advent, LinkedList } from '../src/main';
import { expect } from 'chai';

describe('LinkedList', () => {
  let ll;

  beforeEach(() => {
    ll = new LinkedList([0, 1, 2]);
  });

  describe('#new', () => {
    it('instantiates nodes based on passed values and a root', () => {
      expect(ll.root.val).to.eql(0);
      expect(ll.root.next.val).to.eql(1);
      expect(ll.root.next.next.val).to.eql(2);
    });

    it('sets previous nodes', () => {
      expect(ll.root.next.prev.val).to.eql(0);
    });

    it('handles wrapping', () => {
      expect(ll.root.prev.val).to.eql(2);
      expect(ll.root.prev.next.val).to.eql(0);
    });
  });

  describe('#insert', () => {
    it('adds a new node to the right of the passed node', () => {
      const newNode = ll.insert(ll.root, 99);
      expect(newNode.val).to.eql(99);
      expect(newNode.next.val).to.eql(1);
      expect(newNode.prev.val).to.eql(0);
      expect(ll.root.next.val).to.eql(99);
      expect(ll.root.prev.prev.prev.val).to.eql(99);
    });
  });

  describe('#destroy', () => {
    it('removes a passed node and resets the links', () => {
      ll.destroy(ll.root.next);
      expect(ll.root.next.val).to.eql(2);
      expect(ll.root.next.prev.val).to.eql(0);
    });

    it('resets the root', () => {
      ll.destroy(ll.root);
      expect(ll.root.val).to.eql(1);
    });
  });

  describe('#toArray', () => {
    it('returns an array starting at the root', () => {
      expect(ll.toArray()).to.eql([0, 1, 2]);
    });
  });
});

describe('Advent', () => {
  const input: string = `
9 players; last marble is worth 25 points
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a player count', () => {
      expect(ad.players).to.eql(9);
    });

    it('inits a marble count', () => {
      expect(ad.marbles).to.eql(25);
    });

    it('inits a 0 element linked list', () => {
      expect(ad.circle.toArray()).to.eql([0]);
    });

    it('inits a current position to the circle root', () => {
      expect(ad.cur.val).to.eql(0);
    });

    it('inits a current marble', () => {
      expect(ad.curMarble).to.eql(1);
    });

    it('inits player scores', () => {
      expect(ad.playerScores).to.eql([0, 0, 0, 0, 0, 0, 0, 0, 0]);
    });
  });

  describe('#step', () => {
    it('increments the current marble and node', () => {
      ad.step();
      expect(ad.curMarble).to.eql(2);
      expect(ad.cur.val).to.eql(1);
    });

    it('places a marble two steps forward', () => {
      ad.step();
      expect(ad.circle.toArray()).to.eql([0, 1]);
      ad.step();
      expect(ad.circle.toArray()).to.eql([0, 2, 1]);
      ad.step();
      expect(ad.circle.toArray()).to.eql([0, 2, 1, 3]);
      ad.step();
      expect(ad.circle.toArray()).to.eql([0, 4, 2, 1, 3]);
    });

    describe('if the marble is divisible by 23', () => {
      beforeEach(() => {
        for (let i = 0; i < 22; i++) {
          ad.step();
        }
      });

      it('skips the marble', () => {
        ad.step();
        expect(ad.curMarble).to.eql(24);
        expect(ad.circle.toArray()).to.not.include(23);
      });

      it('removes the marble 7 steps left', () => {
        ad.step();
        expect(ad.circle.toArray()).to.not.include(9);
      });

      it('sets the new current marble to the one 6 steps to the left', () => {
        ad.step();
        expect(ad.cur.val).to.eql(19);
      });

      it('updates the player score to the sum of both marbles', () => {
        ad.step();
        expect(ad.playerScores[4]).to.eql(23 + 9);
        expect(ad.playerScores).to.eql([0, 0, 0, 0, 32, 0, 0, 0, 0]);
      });
    });
  });

  describe('#play', () => {
    it('plays the game until there are no remaining marbles', () => {
      ad.play();
      expect(ad.cur.val).to.eql(25);
      expect(ad.playerScores).to.eql([0, 0, 0, 0, 32, 0, 0, 0, 0]);
    });
  });

  context('verification', () => {
    const a = [
      '10 players; last marble is worth 1618 points: high score is 8317',
      '13 players; last marble is worth 7999 points: high score is 146373',
      '17 players; last marble is worth 1104 points: high score is 2764',
      '21 players; last marble is worth 6111 points: high score is 54718',
      '30 players; last marble is worth 5807 points: high score is 37305',
    ];

    for (const verif of a) {
      it(`yields the correct high score for: ${verif}`, () => {
        const [input, scoreStr] = verif.split(': high score is ');
        ad = new Advent(input);
        ad.play();
        expect(Math.max(...ad.playerScores)).to.eql(parseInt(scoreStr));
      });
    }
  });
});
