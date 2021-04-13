import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const strongest = ad.strongestBot();
console.log('Strongest', strongest);
const inRange = ad.inRange(...strongest);
console.log('In Range:', inRange.length);

console.log(ad.grid.minMax());

const solved = ad.solver();
console.log('Solver: ', solved);
const [x, y, z] = solved;
console.log('Distance to origin:', x + y + z);

// 123420943 - your answer is too high.

// From another solver, verified correct answer
// position: (58376721, 24011800, 22112521)
// num in range: 985
// distance: 104501042
