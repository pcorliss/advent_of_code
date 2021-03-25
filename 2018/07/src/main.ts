export default class Advent {
  dependencies: Map<string, string[]>;
  reverseDep: Map<string, string[]>;
  steps: Set<string>;
  stepLength: number;

  constructor(input: string) {
    this.dependencies = new Map<string, string[]>();
    this.reverseDep = new Map<string, string[]>();
    this.steps = new Set<string>();

    // Step C must be finished before step A can begin.
    const stepRegex = /^Step (\w) must be finished before step (\w) can begin.$/;
    for (const line of input.split('\n')) {
      const [_, stepBefore, stepResult] = line.match(stepRegex);
      const dependas = this.dependencies.get(stepResult) || [];
      if (dependas.length === 0) {
        this.dependencies.set(stepResult, dependas);
      }
      dependas.push(stepBefore);

      const reverseDependency = this.reverseDep.get(stepBefore) || [];
      if (reverseDependency.length === 0) {
        this.reverseDep.set(stepBefore, reverseDependency);
      }
      reverseDependency.push(stepResult);

      if (!this.steps.has(stepBefore)) {
        this.stepLength = (this.stepLength || 0) + 1;
      }
      if (!this.steps.has(stepResult)) {
        this.stepLength = (this.stepLength || 0) + 1;
      }
      this.steps.add(stepResult);
      this.steps.add(stepBefore);
    }
  }

  calcOrder(): string[] {
    const orderedSteps = [];
    const available = [];

    // find start
    for (const step of this.steps) {
      if (this.dependencies.get(step) === undefined) {
        available.push(step);
        console.log(`First Step Found: ${step}`);
      }
    }

    available.sort();
    orderedSteps.push(available.shift());

    let i = 0;
    while (orderedSteps.length < this.stepLength) {
      const lastStep = orderedSteps[orderedSteps.length - 1];
      let candidates = this.reverseDep.get(lastStep) || [];
      candidates = candidates.filter((step) =>
        this.dependencies
          .get(step)
          .every((depStep) => orderedSteps.includes(depStep)),
      );
      available.push(...candidates);
      available.sort();
      console.log(`${i}: Steps: ${orderedSteps} Available: ${available} Candidates: ${candidates} from ${this.reverseDep.get(lastStep)}`)
      if (available.length === 0) {
        throw 'No Available candidates!!!';
      }
      orderedSteps.push(available.shift());
      i++;
      if (i > 100) {
        throw 'Too many iterations!!!';
      }
    }
    return orderedSteps;
  }
}
