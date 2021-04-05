import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]

Before: [0, 0, 3, 3]
9 0 0 1
After:  [0, 0, 3, 3

Before: [0, 1, 2, 3]
9 0 0 3
After:  [0, 1, 2, 0]

Before: [2, 3, 0, 2]
0 1 0 2
After:  [2, 3, 6, 2]

5 1 0 0
12 0 2 0
5 0 0 2
12 2 3 2
5 0 0 3
12 3 1 3
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits samples', () => {
      expect(ad.samples).to.have.lengthOf(4);
      expect(ad.samples[0].before).to.eql([3, 2, 1, 1]);
      expect(ad.samples[0].after).to.eql([3, 2, 2, 1]);
      expect(ad.samples[0].code).to.eql([9, 2, 1, 2]);
    });

    it('inits instructions', () => {
      expect(ad.instructions).to.have.lengthOf(6);
      expect(ad.instructions[0]).to.eql([5, 1, 0, 0]);
    });

    it('inits registers', () => {
      expect(ad.registers).to.eql([0, 0, 0, 0]);
    });
  });

  describe('#process', () => {
    it('addr (add register) stores into register C the result of adding register A and register B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('addr', 0, 1, 2)).to.eql([3, 7, 10, 0]);
      expect(ad.registers).to.eql([3, 7, 10, 0]);
    });

    it('addi (add immediate) stores into register C the result of adding register A and value B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('addi', 0, 1, 2)).to.eql([3, 7, 4, 0]);
    });

    it('mulr (multiply register) stores into register C the result of multiplying register A and register B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('mulr', 0, 1, 2)).to.eql([3, 7, 21, 0]);
    });

    it('muli (multiply immediate) stores into register C the result of multiplying register A and value B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('muli', 0, 3, 2)).to.eql([3, 7, 9, 0]);
    });

    it('banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('banr', 0, 1, 2)).to.eql([3, 7, 3, 0]);
    });

    it('bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('bani', 0, 2, 2)).to.eql([3, 7, 2, 0]);
    });

    it('borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('borr', 0, 1, 2)).to.eql([3, 7, 7, 0]);
    });

    it('bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('bori', 0, 1, 2)).to.eql([3, 7, 3, 0]);
    });

    it('setr (set register) copies the contents of register A into register C. (Input B is ignored.)', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('setr', 0, 1, 2)).to.eql([3, 7, 3, 0]);
    });

    it('seti (set immediate) stores value A into register C. (Input B is ignored.)', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('seti', 8, 1, 2)).to.eql([3, 7, 8, 0]);
    });

    it('gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('gtir', 8, 1, 2)).to.eql([3, 7, 1, 0]);
      expect(ad.process('gtir', 7, 1, 2)).to.eql([3, 7, 0, 0]);
    });

    it('gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('gtri', 0, 2, 2)).to.eql([3, 7, 1, 0]);
      expect(ad.process('gtri', 3, 2, 2)).to.eql([3, 7, 0, 0]);
    });

    it('gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('gtrr', 1, 0, 2)).to.eql([3, 7, 1, 0]);
      expect(ad.process('gtrr', 0, 1, 2)).to.eql([3, 7, 0, 0]);
    });

    it('eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('eqir', 7, 1, 2)).to.eql([3, 7, 1, 0]);
      expect(ad.process('eqir', 0, 0, 2)).to.eql([3, 7, 0, 0]);
    });

    it('eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('eqri', 1, 7, 2)).to.eql([3, 7, 1, 0]);
      expect(ad.process('eqri', 0, 0, 2)).to.eql([3, 7, 0, 0]);
    });

    it('eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.', () => {
      ad.registers = [3, 7, 0, 0];
      expect(ad.process('eqrr', 0, 0, 2)).to.eql([3, 7, 1, 0]);
      expect(ad.process('eqrr', 0, 1, 2)).to.eql([3, 7, 0, 0]);
    });
  });

  describe('#possible', () => {
    it('returns a set of possible opcode matches', () => {
      const possibilities = ad.possible(ad.samples[0]);
      expect([...possibilities]).to.have.members(['mulr', 'addi', 'seti']);
    });
  });

  describe('#deduce', () => {
    it('runs all the samples and produces the best guess', () => {
      expect([...ad.deduce().get(9)]).to.have.members(['mulr', 'addi', 'seti']);
      expect([...ad.deduce().get(0)]).to.have.members(['mulr']);
    });
  });

  describe('#reduceDeduce', () => {
    it('reduces deductions down to their base', () => {
      const deductions = new Map<number, Set<string>>();
      deductions.set(2, new Set(['a', 'b', 'c']));
      deductions.set(1, new Set(['a', 'b']));
      deductions.set(0, new Set(['a']));
      expect(ad.reduceDeduce(deductions).get(0)).to.eql('a');
      expect(ad.reduceDeduce(deductions).get(1)).to.eql('b');
      expect(ad.reduceDeduce(deductions).get(2)).to.eql('c');
    });

    it('sets the opCode Mapping', () => {
      const deductions = new Map<number, Set<string>>();
      deductions.set(2, new Set(['a', 'b', 'c']));
      deductions.set(1, new Set(['a', 'b']));
      deductions.set(0, new Set(['a']));

      const finalDeductions = ad.reduceDeduce(deductions);
      expect(ad.opCodeMap).to.eql(finalDeductions);
    });
  });

  // describe('#runInst', () => {

  // });
});
