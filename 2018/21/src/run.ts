import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
ad.registers[0] = 11050031;
ad.run(false, 100000);
if (ad.halt()) {
  console.log(ad.registers);
}

ad = new Advent(input_str);
ad.run(true, 1000000);
// for (let i = 0; i < 1000000; i++) {
//   ad = new Advent(input_str);
//   ad.registers[0] = i;
//   ad.run(false, 1000);
//   if (ad.halt()) {
//     console.log(i, ad.registers);
//   }
// }

let r = [0,0,0,0,0,0];
r = [0,0,0,0,0,0];
run(r);

run(r: number[]): number[] {
  //  0  r[5] = 123 // seti 123 0 5
  //  1  r[5] &= 456 // bani 5 456 5
  //  2  r[5] = r[5] == 72 ? 1 : 0// eqri 5 72 5
  //  3  r[2] += r[5] // NOOP OR JMP 5 addr 5 2 2
  //  4  r[2] = 0 // JMP 1 seti 0 0 2
  r[5] = 123 & 456;
  while (r[5] != 72) {
    r[5] &= 456;
  }

  //  5  r[5] = 0 // seti 0 9 5
  r[5] = 0;

  //  6  r[3] = r[5] | 65536 // bori 5 65536 3
  //  7  r[5] = 7586220 // seti 7586220 4 5
  //  8  r[1] = r[3] & 255 // bani 3 255 1
  //  9  r[5] += r[1] // addr 5 1 5
  // 10  r[5] &= 16777215 // bani 5 16777215 5
  // 11  r[5] *= 65899 // muli 5 65899 5
  // 12  r[5] &= 16777215 // bani 5 16777215 5

  r[3] = r[5] | 65536; // 6 // bori 5 65536 3
  r[5] = 7586220; // seti 7586220 4 5

  r[1] = r[3] & 255; // 8 // bani 3 255 1
  r[5] += r[1]; // addr 5 1 5
  r[5] &= 16777215; // bani 5 16777215 5
  r[5] *= 65899; // muli 5 65899 5
  r[5] &= 16777215; // bani 5 16777215 5

  // 13  r[1] = 256 > r[3] ? 1 : 0 // gtir 256 3 1
  // 14  r[2] += r[1] // noop OR JMP 16 addr 1 2 2
  // 15  r[2] += 1 // JMP 17 addi 2 1 2
  // 16  r[2] = 27 // JMP 28 seti 27 9 2

  // JMP 16 -> JMP 28
  if (256 > r[3]) {
    // 28  r[1] = r[5] == r[0] ? 1 : 0 // eqrr 5 0 1
    // 29  r[2] += r[1] // noop OR HALT addr 1 2 2
    // 30  r[2] = 5 // JMP 6 seti 5 0 2
    if (r[5] == r[0]) {
      return;
    } else {
      r[2] = 5; // JMP 6 seti 5 0 2
    }
  }

  // JMP 17
  // 17  r[1] = 0 // seti 0 9 1
  // 18  r[4] = r[1] + 1 // addi 1 1 4
  // 19  r[4] *= 256 // muli 4 256 4
  r[1] = 0; // seti 0 9 1

  r[4] = r[1] + 1; // addi 1 1 4
  r[4] *= 256; // muli 4 256 4

  // 20  r[4] = r[4] > r[3] ? 1 : 0 // gtrr 4 3 4
  // 21  r[2] += r[4]// noop OR JMP 23 -> JMP 26 addr 4 2 2
  // 22  r[2] += 1 // JMP 24 addi 2 1 2
  // 23  r[2] = 25 // JMP 26 seti 25 4 2
  // JMP 23 -> JMP 26
  if (r[4] > r[3]) {
    // 26  r[3] = r[1] // setr 1 6 3
    // 27  r[2] = 7 // JMP 8 seti 7 8 2
    r[3] = r[1]; // setr 1 6 3
    r[2] = 7; // JMP 8 seti 7 8 2
  // JMP 24
  } else {
    // 24  r[1] += 1 // addi 1 1 1
    // 25  r[2] = 17 // JMP 17 seti 17 2 2
    r[1] += 1; // addi 1 1 1
    r[2] = 17; // JMP 18 seti 17 2 2
  }
  return r;
}
