import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const [x, y] = ad.largestBlock();
console.log(`Coords ${x}, ${y}`);
const power = ad.blockPowerLevel(x, y);
console.log(`Power: ${power}`);

const powerCoords = ad.largestBlock(1, 300);
console.log(`Coords ${powerCoords}`);
const bigPower = ad.blockPowerLevel(...powerCoords);
console.log(`Power: ${bigPower}`);
