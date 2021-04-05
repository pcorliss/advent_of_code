type Sample = {
  before: number[];
  after: number[];
  code: number[];
};

class Advent {
  samples: Sample[];
  instructions: number[][];
  registers: number[];
  opCodeMap: Map<number, string>;

  constructor(input: string) {
    this.samples = [];
    this.instructions = [];
    this.registers = [0, 0, 0, 0];

    let inProgressSample: Sample = { before: [], after: [], code: [] };
    for (const line of input.split('\n')) {
      if (line.startsWith('Before: ')) {
        const [, codes] = line.split(': ');
        inProgressSample.before = codes
          .replace(/[\[\]]/g, '')
          .split(', ')
          .map((n) => parseInt(n));
      } else if (line.startsWith('After: ')) {
        const [, codes] = line.split(': ');
        inProgressSample.after = codes
          .replace(/[\[\]]/g, '')
          .split(', ')
          .map((n) => parseInt(n));
        this.samples.push(inProgressSample);
        inProgressSample = { before: [], after: [], code: [] };
      } else if (inProgressSample.before.length != 0) {
        inProgressSample.code = line.split(' ').map((char) => parseInt(char));
      } else if (line.length > 0) {
        const codes = line.split(' ').map((char) => parseInt(char));
        this.instructions.push(codes);
      }
    }
  }

  process(op: string, a: number, b: number, c: number): number[] {
    switch (op) {
      case 'addr':
        this.registers[c] = this.registers[a] + this.registers[b];
        break;
      case 'addi':
        this.registers[c] = this.registers[a] + b;
        break;
      case 'mulr':
        this.registers[c] = this.registers[a] * this.registers[b];
        break;
      case 'muli':
        this.registers[c] = this.registers[a] * b;
        break;
      case 'banr':
        this.registers[c] = this.registers[a] & this.registers[b];
        break;
      case 'bani':
        this.registers[c] = this.registers[a] & b;
        break;
      case 'borr':
        this.registers[c] = this.registers[a] | this.registers[b];
        break;
      case 'bori':
        this.registers[c] = this.registers[a] | b;
        break;
      case 'setr':
        this.registers[c] = this.registers[a];
        break;
      case 'seti':
        this.registers[c] = a;
        break;
      case 'gtir':
        this.registers[c] = a > this.registers[b] ? 1 : 0;
        break;
      case 'gtri':
        this.registers[c] = this.registers[a] > b ? 1 : 0;
        break;
      case 'gtrr':
        this.registers[c] = this.registers[a] > this.registers[b] ? 1 : 0;
        break;
      case 'eqir':
        this.registers[c] = a == this.registers[b] ? 1 : 0;
        break;
      case 'eqri':
        this.registers[c] = this.registers[a] == b ? 1 : 0;
        break;
      case 'eqrr':
        this.registers[c] = this.registers[a] == this.registers[b] ? 1 : 0;
        break;
      default:
        throw `Unrecognized op code ${op}`;
    }
    return this.registers;
  }

  opCodes = [
    'addr',
    'addi',
    'mulr',
    'muli',
    'banr',
    'bani',
    'borr',
    'bori',
    'setr',
    'seti',
    'gtir',
    'gtri',
    'gtrr',
    'eqir',
    'eqri',
    'eqrr',
  ];

  arrayEquals(a: Array<any>, b: Array<any>): boolean {
    return a.length === b.length && a.every((val, index) => val === b[index]);
  }

  possible(sample: Sample): Set<string> {
    const possibilities = new Set<string>();
    for (const code of this.opCodes) {
      this.registers = sample.before.map((n) => n);
      const [, a, b, c] = sample.code;
      // console.log(`Testing ${code} against ${a}, ${b}, ${c}`, this.registers);
      this.process(code, a, b, c);
      // console.log(`Result  ${code} against ${a}, ${b}, ${c}`, this.registers);
      if (this.arrayEquals(this.registers, sample.after)) {
        possibilities.add(code);
      }
    }
    return possibilities;
  }

  deduce(): Map<number, Set<string>> {
    const deductions = new Map<number, Set<string>>();

    for (const sample of this.samples) {
      const [opCode] = sample.code;
      const opCodeDeductions = deductions.get(opCode) || new Set(this.opCodes);
      const newPossibilities = this.possible(sample);

      // if( opCode == 15) {
      //   console.log("Sample: ", sample);
      //   console.log("Possible: ", newPossibilities);
      // }

      const intersection = new Set(
        [...opCodeDeductions].filter((x) => newPossibilities.has(x)),
      );
      // console.log("New Possibilities", newPossibilities, sample, intersection);
      deductions.set(opCode, intersection);
    }

    // console.log("Deductions:", deductions);
    return deductions;
  }

  reduceDeduce(
    originalDeductions: Map<number, Set<string>>,
  ): Map<number, string> {
    const finalDeductions = new Map();
    const deductions: Map<number, Set<string>> = new Map(
      originalDeductions.entries(),
    );

    const excludeList = new Set<string>();
    let i = 0;

    while ([...deductions.values()].some((p) => p.size > 1)) {
      // console.log('Pre  Deductions:', deductions);
      for (const [opCode, possibilities] of deductions.entries()) {
        if (possibilities.size == 1) {
          const [opCodeMapping] = [...possibilities];
          excludeList.add(opCodeMapping);
        } else {
          const difference = new Set(
            [...possibilities].filter((x) => !excludeList.has(x)),
          );
          deductions.set(opCode, difference);
        }
      }
      i++;
      if (i > 100) {
        throw 'Too many iterations!!!';
      }
      // console.log('Post Deductions:', deductions);
    }

    for (const [opCode, possibilities] of deductions.entries()) {
      const [opCodeMapping] = [...possibilities];
      finalDeductions.set(opCode, opCodeMapping);
    }

    // console.log('Final Deductions:', finalDeductions);
    this.opCodeMap = finalDeductions;
    return finalDeductions;
  }

  runInst(): void {
    for (const inst of this.instructions) {
      const [op, a, b, c] = inst;
      this.process(this.opCodeMap.get(op), a, b, c);
    }
  }
}

export { Advent };
