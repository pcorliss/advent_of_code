import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
ad.registers[0] = 11050031;
ad.run(false, 100000);
if (ad.halt()) {
  console.log(ad.registers);
}
// for (let i = 0; i < 1000000; i++) {
//   ad = new Advent(input_str);
//   ad.registers[0] = i;
//   ad.run(false, 1000);
//   if (ad.halt()) {
//     console.log(i, ad.registers);
//   }
// }
