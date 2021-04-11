import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const risk = ad.risk();
console.log('Risk', risk);
const min = ad.findPath(...ad.target);
console.log('Min: ', min);

// 1108: That's not the right answer; your answer is too high.
