import Advent from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
ad.fillGrid();
const overlaps = ad.overlapCount();
console.log(`Overlaps: ${overlaps}`);
const noOverlaps = ad.noOverlaps();
console.log(`No Overlaps: ${noOverlaps}`);
