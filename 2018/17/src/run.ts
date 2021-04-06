import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
ad.pourPrime();
console.log(ad.grid.render());

console.log("Wet Tiles: ", ad.wetTiles());

// That's not the right answer; your answer is too low. 37066
// Output seems to show weird gaps on overflows `|||||.||||||`

for (const [line, num] of ad.grid.render().split('\n')) {
  if (line.includes('|||.|||')) {
    console.log("Line: ", line);
    console.log(num);
    break;
  }
}