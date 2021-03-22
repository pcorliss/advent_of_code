import Advent from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const sleepiest = ad.sleepiestGuard();
console.log(`Sleepiest Guard: ${sleepiest}`);
const minute = ad.sleepiestMinute(sleepiest);
console.log(`Sleepiest Minute: ${minute}`);
console.log(`Mult ${sleepiest * minute}`);
const [guard, minutePrime, amount] = ad.sleepiestGuardAtMinute();
console.log(`Sleepiest At Minute: ${guard} ${minutePrime} ${amount}`);
console.log(`Mult ${guard * minutePrime}`);