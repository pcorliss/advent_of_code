import Advent from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const reducedPoly = ad.reduceAll(ad.polymer);
console.log('Reduced Poly:', reducedPoly);
console.log('Units:', reducedPoly.length);
