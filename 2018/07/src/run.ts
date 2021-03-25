import Advent from '../src/main';
import fs = require('fs');

const input_str: string = fs.readFileSync('input.txt', 'utf8');

const ad = new Advent(input_str);
const steps = ad.calcOrder();
console.log(`Steps: ${steps.join('')}`);

const [workerSteps, t] = ad.workOrder(5, 60);
console.log(`Time: ${t}`);
console.log(`Steps: ${workerSteps.join('')}`);

// 892: That's not the right answer; your answer is too high.
