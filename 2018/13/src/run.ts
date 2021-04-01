import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
while (ad.collisions.length == 0) {
  ad.tick();
  console.log(ad.carts);
}

console.log(`Collisions:`,ad.collisions)