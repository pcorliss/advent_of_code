import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const score = ad.runUntilFinished();
console.log(ad.actors);
console.log(ad.render());
console.log(`Score: ${score}`);
