import Advent from '../src/main';
import { expect } from 'chai';

describe('Node', () => {
  let ad;

  beforeEach(() => {
    ad = new Advent('');
  });

  describe('#metadataSum', () => {
    it('sums up its own metadata', () => {
      const node = ad.buildNode([0, 3, 1, 2, 3], 0)[0];
      expect(node.metadataSum()).to.eql(6);
    });

    it('sums up children metadata as well', () => {
      const node = ad.buildNode([2, 3, 0, 2, 4, 5, 0, 1, 6, 1, 2, 3], 0)[0];
      expect(node.metadataSum()).to.eql(21);
    });
  });

  describe('#value', () => {
    it('sums up the metadata if there are no children', () => {
      const node = ad.buildNode([0, 3, 1, 2, 3], 0)[0];
      expect(node.value()).to.eql(6);
    });

    it('if it has children metadata refers to their index - 1', () => {
      const node = ad.buildNode([1, 1, 0, 2, 3, 4, 1], 0)[0];
      expect(node.value()).to.eql(7);
    });

    it('handles multiple children', () => {
      const node = ad.buildNode(
        [3, 2, 0, 2, 3, 4, 0, 1, 1, 0, 1, 6, 2, 1],
        0,
      )[0];
      expect(node.value()).to.eql(8);
    });

    it('handles non-existant indexes', () => {
      const node = ad.buildNode([1, 2, 0, 2, 3, 4, 5, 0], 0)[0];
      expect(node.value()).to.eql(0);
    });

    it('handles the sample input', () => {
      const node = ad.buildNode(
        [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2],
        0,
      )[0];
      expect(node.value()).to.eql(66);
    });
  });
});

describe('Advent', () => {
  const input: string = `
2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of numbers', () => {
      expect(ad.numbers).to.have.lengthOf(16);
      expect(ad.numbers[0]).to.eql(2);
    });

    it('inits a root node', () => {
      expect(ad.root.metadata).to.eql([1, 1, 2]);
      expect(ad.root.children).to.have.lengthOf(2);
    });
  });

  describe('#buildNode', () => {
    it('takes a list of numbers and builds a node without children or metadata', () => {
      const node = ad.buildNode([0, 0], 0)[0];
      expect(node.children).to.eql([]);
      expect(node.metadata).to.eql([]);
    });

    it('creates a node with metadata', () => {
      const node = ad.buildNode([0, 3, 1, 2, 3], 0)[0];
      expect(node.children).to.eql([]);
      expect(node.metadata).to.eql([1, 2, 3]);
    });

    it('creates a node with empty children nodes and metadata', () => {
      const node = ad.buildNode([2, 2, 0, 0, 0, 0, 3, 4], 0)[0];
      expect(node.children).to.have.lengthOf(2);
      expect(node.children[0].children).to.eql([]);
      expect(node.children[0].metadata).to.eql([]);
      expect(node.children[1].children).to.eql([]);
      expect(node.children[1].metadata).to.eql([]);
      expect(node.metadata).to.eql([3, 4]);
    });

    it('creates children nodes with metadata', () => {
      const node = ad.buildNode(
        [2, 2, 0, 2, 99, 98, 0, 3, 100, 101, 102, 3, 4],
        0,
      )[0];
      expect(node.children).to.have.lengthOf(2);
      expect(node.children[0].children).to.eql([]);
      expect(node.children[0].metadata).to.eql([99, 98]);
      expect(node.children[1].children).to.eql([]);
      expect(node.children[1].metadata).to.eql([100, 101, 102]);
      expect(node.metadata).to.eql([3, 4]);
    });

    it('creates nested children', () => {
      const node = ad.buildNode(
        [2, 2, 1, 2, 0, 2, 88, 89, 99, 98, 0, 3, 100, 101, 102, 3, 4],
        0,
      )[0];
      expect(node.children).to.have.lengthOf(2);
      expect(node.children[0].children).to.have.lengthOf(1);
      expect(node.children[0].children[0].metadata).to.eql([88, 89]);
      expect(node.children[0].metadata).to.eql([99, 98]);
      expect(node.children[1].children).to.eql([]);
      expect(node.children[1].metadata).to.eql([100, 101, 102]);
      expect(node.metadata).to.eql([3, 4]);
    });

    it('sets the parent of the node', () => {
      const node = ad.buildNode([1, 0, 0, 0], 0)[0];
      expect(node.children[0].parent).to.eql(node);
    });

    it('handles empty metadata', () => {
      const node = ad.buildNode([1, 0, 0, 2, 3, 4], 0)[0];
      expect(node.children[0].metadata).to.eql([3, 4]);
    });
  });
});
