import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
let i = 0;
while (ad.collisions.length == 0) {
  ad.tick();
  i++;
  // console.log(ad.carts);
}

console.log(`Collisions:`, ad.collisions);
let previousLength = 0;
while (ad.carts.length > 2) {
  ad.tick();
  if (previousLength != ad.carts.length) {
    console.log(
      `Steps: ${i} Length: ${ad.carts.length} Collisions: ${ad.collisions.length}`,
    );
    console.log(ad.carts);
    previousLength = ad.carts.length;
  }
  i++;
}

const lastCart = ad.carts[0];
console.log(`Last Cart Location: ${lastCart[0]},${lastCart[1]}`, lastCart);

//120,69 is not correct
// 134, 117 is not correct, space issue?
