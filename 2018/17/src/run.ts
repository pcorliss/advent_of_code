import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
ad.pourPrime();
console.log(ad.grid.render());

console.log('Wet Tiles: ', ad.wetTiles());
console.log('Water Tiles: ', ad.waterTiles());

// That's not the right answer; your answer is too low. 37066
// Output seems to show weird gaps on overflows `|||||.||||||`

// That's not the right answer; your answer is too high. 37077

let i = 0;
for (const [idx, line] of ad.grid.render().split('\n').entries()) {
  if (line.includes('|||.|||')) {
    i = 15;
    console.log('\n');
  }
  if (i > 0) {
    i--;
    console.log('Line: ', idx, line);
  }
}
