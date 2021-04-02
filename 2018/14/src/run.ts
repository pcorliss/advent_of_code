import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const creates = ad.numRecipies;
while (ad.scores.length < creates + 10) {
  ad.create();
}
const lastTen = ad.scores.slice(creates, creates + 10).join('');
console.log(`Last Ten: ${lastTen}`);