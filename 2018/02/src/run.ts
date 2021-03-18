import Advent from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
console.log('Frequency: ', ad.frequency());

console.log('Dupe: ', ad.first_dupe());
