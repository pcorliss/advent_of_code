import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const strongest = ad.strongestBot();
console.log('Strongest', strongest);
const inRange = ad.inRange(...strongest);
console.log('In Range:', inRange.length);
