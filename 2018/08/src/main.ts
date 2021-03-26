class Node {
  metadata: number[];
  children: Node[];
  parent: Node;

  constructor() {
    this.children = [];
    this.metadata = [];
    this.parent = null;
  }

  metadataSum(): number {
    const sum = this.metadata.reduce((acc, n) => acc + n);
    return this.children.reduce((acc, c) => acc + c.metadataSum(), sum);
  }

  value(): number {
    if (this.children.length > 0) {
      return this.metadata.reduce((acc, n) => {
        if (n > 0 && n - 1 < this.children.length) {
          return acc + this.children[n - 1].value();
        } else {
          return acc;
        }
      }, 0);
    } else {
      return this.metadata.reduce((acc, n) => acc + n);
    }
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
