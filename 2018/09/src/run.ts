import { Advent } from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

let ad = new Advent(input_str);
ad.play();
console.log(`Player Scores: ${ad.playerScores}`);
console.log(`High Score: ${Math.max(...ad.playerScores)}`);

ad = new Advent(input_str);
ad.marbles *= 100;
ad.play();
console.log(`High Score: ${Math.max(...ad.playerScores)}`);
