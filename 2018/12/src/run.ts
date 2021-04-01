import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
for (let i = 0; i < 20; i++) {
  ad.step();
}
const sum = [...ad.plants].reduce((sum, i) => sum + i, 0);
console.log(`Sum: ${sum}`);

const ad2 = new Advent(input_str);
let j = 5;
for (let i = 1; i < 50000000000; i++) {
  ad2.step();
  if (i % j == 0) {
    console.log(`Steps: ${i}`);
    console.log("Sum:", [...ad2.plants].reduce((sum, k) => sum + k, 0));
    j = j * 10;
  }
}
const sum2 = [...ad2.plants].reduce((sum, i) => sum + i, 0);
console.log(`Sum: ${sum2}`);

// Sum: 1696
// Steps: 5
// Sum: 1564
// Steps: 50
// Sum: 2215
// Steps: 500
// Sum: 17458
// Steps: 5000
// Sum: 179458
// Steps: 50000
// Sum: 1799458
// Steps: 500000
// Sum: 17999458

// As steps advance sum is predictable and just starts adding 9s to the center.
// 1799999999458 ended up being the correct answer. Not quite sure why though.