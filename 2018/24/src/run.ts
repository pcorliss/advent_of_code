import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
console.log(ad.groups);
ad.combat();
const units = ad.groups.reduce((acc, g) => acc + g.count, 0);
console.log('Units: ', units);

// 21828 - too high
// 21719 - too high