import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);

const threeOrMoreCount = ad.samples.reduce((acc: number, sample) => {
  acc += ad.possible(sample).size >= 3 ? 1 : 0;
  return acc;
}, 0);

console.log('Samples with three or more possible opcodes: ', threeOrMoreCount);

const deductions = ad.reduceDeduce(ad.deduce());
console.log('Deductions:', deductions);

ad.registers = [0, 0, 0, 0];
ad.runInst();
console.log('Registers:', ad.registers);
