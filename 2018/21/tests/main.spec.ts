import { Advent } from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits registers', () => {
      expect(ad.registers).to.eql([0, 0, 0, 0, 0, 0]);
    });

    it('inits instructions', () => {
      expect(ad.instructions).to.have.lengthOf(7);
      expect(ad.instructions[0]).to.eql(['seti', 5, 0, 1]);
    });

    it('inits instruction pointer', () => {
      expect(ad.instructionPointerRegister).to.eql(0);
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

  describe('#step', () => {
    it('increments the instruction pointer by 1', () => {
      ad.step();
      expect(ad.registers[0]).to.eql(1);
    });

    it('executes the instruction', () => {
      // seti 5 0 1 - Set register 1 to val 5
      ad.step();
      expect(ad.registers[1]).to.eql(5);
    });

    it('executes the instruction that the pointer is pointing to', () => {
      ad.registers[0] = 1;
      ad.step();
      expect(ad.registers[1]).to.eql(0);
      expect(ad.registers[2]).to.eql(6);
    });
  });

  describe('#halt', () => {
    it('returns false', () => {
      expect(ad.halt()).to.be.false;
    });

    it('returns true if the instruction pointer register is negative', () => {
      ad.registers[0] = -1;
      expect(ad.halt()).to.be.true;
    });

    it('returns true if the instruction pointer register is beyond the instruction length', () => {
      ad.registers[0] = 7;
      expect(ad.halt()).to.be.true;
    });

    const expectedRegisters = [
      [0, 0, 0, 0, 0, 0],
      [1, 5, 0, 0, 0, 0],
      [2, 5, 6, 0, 0, 0],
      [4, 5, 6, 0, 0, 0],
      [6, 5, 6, 0, 0, 0],
      [7, 5, 6, 0, 0, 9],
    ];
    for (const [steps, expectedRegister] of expectedRegisters.entries()) {
      it(`returns ${expectedRegister} after ${steps}`, () => {
        for (let i = 0; i < steps; i++) {
          ad.step();
        }
        expect(ad.registers).to.eql(expectedRegister);
      });
    }
  });

  describe('#run', () => {
    it('runs until the program halts', () => {
      ad.run();
      expect(ad.registers).to.eql([7, 5, 6, 0, 0, 9]);
    });

    it('runs a max number of instructions before stopping', () => {
      const inputMax: string = `
#ip 1
addi 0 1 0
seti -1 0 1
      `.trim();
      ad = new Advent(inputMax);
      ad.run(false, 100);
      expect(ad.registers).to.eql([50, 0, 0, 0, 0, 0]);
    });
  });
});
