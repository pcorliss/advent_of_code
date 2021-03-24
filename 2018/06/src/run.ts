import Advent from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const largest = ad.largestNonInfiniteArea();
console.log(`Largest: ${largest}`);
const safe = ad.safeArea(10000);
console.log(`Safe Area: ${safe}`);

// 36117: That's not the right answer; your answer is too low.
