interface Group {
  count: number;
  hp: number;
  immune: string[];
  weak: string[];
  dps: number;
  dmgT: string;
  init: number;
  t: string;
}

class Advent {
  groups: Group[];

  constructor(input: string) {
    this.groups = [];
    const reGroup = /^(\d+) units each with (\d+) hit points \((immune to ([\w, ]*)){0,1}.*?(weak to ([\w, ]*)){0,1}\) with an attack that does (\d+) (\w+) damage at initiative (\d+)$/;
    let t = '';
    for (const line of input.split('\n')) {
      if (line.startsWith('Immune System')) {
        t = 'Immune';
      } else if (line.startsWith('Infection:')) {
        t = 'Infection';
      } else if (line.match(reGroup)) {
        const m = line.match(reGroup);
        const g: Group = {
          count: parseInt(m[1]),
          hp: parseInt(m[2]),
          dps: parseInt(m[7]),
          dmgT: m[8],
          init: parseInt(m[9]),
          t: t,
          immune: [],
          weak: [],
        };
        if (m[4]) g.immune = m[4].split(', ');
        if (m[6]) g.weak = m[6].split(', ');
        this.groups.push(g);
      }
    }
  }

  effectivePower(g: Group): number {
    return g.count * g.dps;
  }

  damage(attacker: Group, defender: Group): number {
    if (defender.immune.includes(attacker.dmgT)) return 0;
    if (defender.weak.includes(attacker.dmgT))
      return 2 * this.effectivePower(attacker);
    return this.effectivePower(attacker);
  }

  applyDamage(damage: number, defender: Group): void {
    defender.count -= Math.floor(damage / defender.hp);
    if (defender.count < 0) defender.count = 0;
  }

  targetSelection(): Map<Group, Group> {
    const m = new Map<Group, Group>();
    const groups = this.groups.sort(this.sortTargetSelection);
    let targets = groups.slice();

    for (const g of groups) {
      const target = targets
        .filter((t) => t.t != g.t)
        .sort((a, b) => {
          return (
            this.damage(g, b) * 1000 +
            this.effectivePower(b) * 10 +
            b.init -
            this.damage(g, a) * 1000 -
            this.effectivePower(a) * 10 -
            a.init
          );
        })[0];
      if (target && this.damage(g, target) > 0) {
        targets = targets.filter((t) => t !== target);
        m.set(g, target);
      }
    }

    return m;
  }

  attack(targetMap: Map<Group, Group>): void {
    for (const attacker of this.groups.sort((a, b) => b.init - a.init)) {
      // console.log('Attacker: ', attacker.count);
      if (attacker.count > 0) {
        const defender = targetMap.get(attacker);
        if (defender) {
          // console.log ('\tDefender: ', defender.count);
          const damage = this.damage(attacker, defender);
          this.applyDamage(damage, defender);
          // console.log ('\tDefender: ', defender.count, damage);
        }
      }
    }
  }

  sortTargetSelection(a: Group, b: Group): number {
    const ad = new Advent('');
    return (
      ad.effectivePower(b) * 1000 +
      b.init -
      ad.effectivePower(a) * 1000 -
      a.init
    );
  }

  halt(): boolean {
    const count = new Map<string, number>();
    for (const g of this.groups) {
      const unitCount = (count.get(g.t) || 0) + g.count;
      count.set(g.t, unitCount);
    }
    return [...count.values()].includes(0);
  }

  combat(): void {
    while (!this.halt()) {
      const targets = this.targetSelection();
      this.attack(targets);
    }
  }
}

export { Advent };
