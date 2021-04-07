import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
for (let i = 0; i < 10; i++) {
  ad.step();
}
console.log(ad.grid.render());
const valCount = ad.valueCount();
console.log(valCount);
console.log(
  'Mult:',
  [...valCount.values()].reduce((acc, v) => acc * v, 1)
);
