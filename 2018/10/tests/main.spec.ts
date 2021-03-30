import { Advent, Point } from '../src/main';
import { expect } from 'chai';
import { mkdirSync } from 'node:fs';

describe('Point', () => {
  let p;

  beforeEach(() => {
    p = new Point(9, 1, 0, 2);
  });

  describe('#step', () => {
    it('modifies the position', () => {
      p.step();
      expect(p.x).to.eql(9);
      expect(p.y).to.eql(3);
    });
  });

  describe('#stepBack', () => {
    it('modifies the position', () => {
      p.step();
      p.stepBack();
      expect(p.x).to.eql(9);
      expect(p.y).to.eql(1);
    });
  });
});

describe('Advent', () => {
  const input: string = `
position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits points and velocities', () => {
      expect(ad.points).to.have.lengthOf(31);
      expect(ad.points[0]).to.eql({ x: 9, y: 1, xVel: 0, yVel: 2 });
      expect(ad.points[30]).to.eql({ x: -3, y: 6, xVel: 2, yVel: -1 });
    });
  });

  describe('#step', () => {
    it('modifies all points', () => {
      ad.step();
      expect(ad.points[0]).to.eql({ x: 9, y: 3, xVel: 0, yVel: 2 });
      expect(ad.points[30]).to.eql({ x: -1, y: 5, xVel: 2, yVel: -1 });
    });
  });

  describe('#stepBack', () => {
    it('modifies all points', () => {
      ad.step();
      ad.stepBack();
      expect(ad.points[0]).to.eql({ x: 9, y: 1, xVel: 0, yVel: 2 });
      expect(ad.points[30]).to.eql({ x: -3, y: 6, xVel: 2, yVel: -1 });
    });
  });

  describe('#render', () => {
    const expectedRender: string = `
........#.............
................#.....
.........#.#..#.......
......................
#..........#.#.......#
...............#......
....#.................
..#.#....#............
.......#..............
......#...............
...#...#.#...#........
....#..#..#.........#.
.......#..............
...........#..#.......
#...........#.........
...#.......#..........
    `.trim();
    it('renders the initial state', () => {
      expect(ad.render()).to.eql(expectedRender);
    });
  });

  describe('#compactness', () => {
    it('returns a score indicating how compact the output is', () => {
      // maxX - minX + maxY - minY
      expect(ad.compactness()).to.eql(36);
    });
  });

  describe('#runUntilCompact', () => {
    const expectedRendering: string = `
#...#..###
#...#...#.
#...#...#.
#####...#.
#...#...#.
#...#...#.
#...#...#.
#...#..###
    `.trim();
    it('returns the number of steps required', () => {
      expect(ad.runUntilCompact()[0]).to.eql(3);
    });

    it('returns the rendering', () => {
      expect(ad.runUntilCompact()[1]).to.eql(expectedRendering);
    });
  })
});
