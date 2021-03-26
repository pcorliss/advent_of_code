import { nextTick } from 'node:process';

class Node {
  metadata: number[];
  children: Node[];
  parent: Node;

  constructor() {
    this.children = null;
    this.metadata = null;
    this.parent = null;
  }

  metadataSum(): number {
    const sum = this.metadata.reduce((acc, n) => acc + n);
    return this.children.reduce((acc, c) => acc + c.metadataSum(), sum);
  }
}

export default class Advent {
  root: Node;
  numbers: number[];

  constructor(input: string) {
    this.numbers = input.split(' ').map((n) => parseInt(n));
    this.root = this.buildNode(this.numbers, 0)[0];
  }

  buildNode(nums: number[], idx: number): [Node, number] {
    const node = new Node();
    node.children = [];
    node.metadata = [];
    const children = nums[idx + 0];
    const metadata = nums[idx + 1];

    let i = idx + 2;
    while (node.children.length < children || node.metadata.length < metadata) {
      if (node.children.length < children) {
        const [newChild, newIdx] = this.buildNode(nums, i);
        newChild.parent = node;
        node.children.push(newChild);
        i = newIdx - 1;
      } else {
        node.metadata.push(nums[i]);
      }
      i++;
    }
    return [node, i];
  }
}
