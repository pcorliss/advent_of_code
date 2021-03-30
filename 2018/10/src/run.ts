import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
const [steps, rendering] = ad.runUntilCompact();
console.log(`Steps: ${steps}`);
console.log(rendering);
