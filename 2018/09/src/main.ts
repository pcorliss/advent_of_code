class LinkedList {
  root: Node;

  constructor(vals: number[]) {
    const nodes: Node[] = vals.map((v) => new Node(v));
    this.root = nodes[0];
    for (let i = 0; i < nodes.length; i++) {
      nodes[i].next = nodes[(i + 1) % nodes.length];
      if (i - 1 < 0) {
        nodes[i].prev = nodes[nodes.length - 1];
      } else {
        nodes[i].prev = nodes[i - 1];
      }
    }
  }

  insert(node: Node, val: number): Node {
    const newNode = new Node(val);
    newNode.next = node.next;
    newNode.prev = node;

    newNode.next.prev = newNode;
    node.next = newNode;
    return newNode;
  }

  destroy(node: Node): void {
    node.prev.next = node.next;
    node.next.prev = node.prev;
    if (node === this.root) {
      this.root = node.next;
    }
  }

  toArray(): number[] {
    const retArray: number[] = [];
    let n = this.root;
    while (retArray.length === 0 || n !== this.root) {
      retArray.push(n.val);
      n = n.next;
    }
    return retArray;
  }
}

class Node {
  prev: Node;
  next: Node;
  val: number;

  constructor(val: number) {
    this.val = val;
  }
}

class Advent {
  players: number;
  marbles: number;
  circle: LinkedList;
  cur: Node;
  curMarble: number;
  playerScores: number[];

  constructor(input: string) {
    const r = new RegExp(/^(\d+) players; last marble is worth (\d+) points$/);
    const res = input.match(r);
    this.players = parseInt(res[1]);
    this.marbles = parseInt(res[2]);
    this.circle = new LinkedList([0]);
    this.cur = this.circle.root;
    this.curMarble = 1;
    this.playerScores = new Array(this.players).fill(0);
  }

  step(): void {
    if (this.curMarble % 23 == 0) {
      const leftSix = this.cur.prev.prev.prev.prev.prev.prev;
      const leftSeven = leftSix.prev;
      this.circle.destroy(leftSeven);
      this.cur = leftSix;
      this.playerScores[(this.curMarble - 1) % this.players] +=
        this.curMarble + leftSeven.val;
    } else {
      const next = this.cur.next;
      this.cur = this.circle.insert(next, this.curMarble);
    }
    this.curMarble++;
  }

  play(): void {
    for (let i = 0; i < this.marbles; i++) {
      this.step();
    }
  }
}

export { Advent, LinkedList };
