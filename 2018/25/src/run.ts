import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const constellations = ad.formConstellations();
console.log('Constellations:', constellations);
console.log('Count:', constellations.length);