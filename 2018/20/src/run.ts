import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const steps = ad.fill(ad.pathRegex);
console.log('Steps: ', steps);

const rooms = [...ad.stepGrid.map.values()].reduce((acc, step) => {
  acc += step >= 1000 ? 1 : 0;
  return acc;
}, 0);

console.log('Rooms', rooms);
