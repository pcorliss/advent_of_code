import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
ad.run(false);
console.log('Registers:', ad.registers);

let r = [0, 0, 0, 0, 0, 0];

if (r[0] == 1) {
  r[2] = 10550400;
  r[5] = 10551364;
  r[0] = 0;
} else {
  r[2] = 128;
  r[5] = 964;
}

r[3] = 1;
while (r[3] <= r[5]) {
  r[1] = 1;
  // console.log('ip= 2', r);
  while (r[1] <= r[5]) {
    r[2] = r[3] * r[1];
    // console.log('ip= 3', r, r[2] == r[5]);
    if (r[2] == r[5]) {
      r[0] += r[3];
    }
    r[1]++;
  }
  r[3]++;
}

console.log('R:', r);
r = [0, 0, 0, 0, 0, 964];

for (let i = 1; i <= r[5]; i++) {
  if (r[5] % i == 0) {
    r[0] += i;
  }
}
console.log('R:', r);

r = [0, 0, 0, 0, 0, 10551364];

for (let i = 1; i <= r[5]; i++) {
  if (r[5] % i == 0) {
    r[0] += i;
  }
}
console.log('R:', r);

// ad = new Advent(input_str);
// ad.registers[0] = 1;
// ad.run(true);
// console.log('Registers:', ad.registers);

// Too low 10551365
