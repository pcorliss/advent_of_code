import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
ad.combat();
const units = ad.groups.reduce((acc, g) => acc + g.count, 0);
console.log('Units: ', units);

let boost = 0;
let infectionUnits = 1;
while (infectionUnits != 0) {
  ad = new Advent(input_str);
  ad.boost(boost);
  ad.combat();
  const count = ad.unitCount();
  console.log('Boost:', boost, 'Units:', count);
  infectionUnits = count.get('Infection');
  boost++;
}

// 21828 - too high
// 21719 - too high