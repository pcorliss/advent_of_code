import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
let score = ad.runUntilFinished();
console.log(ad.actors);
console.log(ad.render());
console.log(`Score: ${score}`);


ad = new Advent(input_str);
const attack = ad.lowestAttackPower();
console.log(`Lowest Attack Power: ${attack}`);
ad = new Advent(input_str, attack);
score = ad.runUntilFinished();
console.log(ad.actors);
console.log(ad.render());
console.log(`Score: ${score}`);