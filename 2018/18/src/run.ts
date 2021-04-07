import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
for (let i = 0; i < 10; i++) {
  ad.step();
}
console.log(ad.grid.render());
let valCount = ad.valueCount();
console.log(valCount);
console.log(
  'Mult:',
  [...valCount.values()].reduce((acc, v) => acc * v, 1)
);

ad = new Advent(input_str);
const val = ad.findWithCycle(1000000000);
console.log("Val:", val);
// console.log(ad.grid.render());
// valCount = ad.valueCount();
// console.log(valCount);
// console.log(
//   'Mult:',
//   [...valCount.values()].reduce((acc, v) => acc * v, 1)
// );