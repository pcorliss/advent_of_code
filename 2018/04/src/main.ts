/* eslint-disable @typescript-eslint/no-unused-vars */
export default class Advent {
  guardEvents: Map<Date, string>;
  guardSleep: Map<number, number>;
  guardSleepEvents: Map<number, number[][]>;

  constructor(input: string) {
    this.guardEvents = new Map<Date, string>();
    this.guardSleep = new Map<number, number>();
    this.guardSleepEvents = new Map<number, number[][]>();

    const guardRegex = /^\[([\d\-: ]+)\] (.*)$/;
    const shiftRegex = /^Guard \#(\d+) .*$/;
    const actionRegex = /^(falls|wakes) .*$/;

    let guard: number;
    let awake = true;
    let lastTimestamp: Date;

    for (const line of input.split('\n').sort()) {
      guardRegex.test(line);
      const [_, timestamp, action] = line.match(guardRegex);
      const currentTimestamp = new Date(timestamp);
      this.guardEvents.set(currentTimestamp, action);

      if (shiftRegex.test(action)) {
        const [_, guardNumber] = action.match(shiftRegex);
        if (!awake) {
          console.log(line);
          throw `Previous Guard ${guard} was asleep when relieved!!!`;
        }
        guard = parseInt(guardNumber);
        awake = true;
      }

      if (actionRegex.test(action)) {
        const [_, act] = action.match(actionRegex);
        if (act === 'falls') {
          awake = false;
        } else {
          awake = true;
          const duration: number = (+currentTimestamp - +lastTimestamp) / 60000;
          const prevDuration = this.guardSleep.get(guard) || 0;
          this.guardSleep.set(guard, duration + prevDuration);

          if (!this.guardSleepEvents.has(guard)) {
            this.guardSleepEvents.set(guard, []);
          }
          const events = this.guardSleepEvents.get(guard);
          events.push([+lastTimestamp, +currentTimestamp, duration]);
        }
      }

      lastTimestamp = currentTimestamp;
    }
  }

  sleepiestGuard(): number {
    let maxGuard = 0;
    let maxAmount = 0;
    for (const [guard, amount] of this.guardSleep) {
      if (maxAmount < amount) {
        maxAmount = amount;
        maxGuard = guard;
      }
    }
    return maxGuard;
  }

  sleepiestMinute(guard: number): number {
    const events = this.guardSleepEvents.get(guard);
    const minuteMap: number[] = [];
    let maxMinute = 0;
    let maxAmount = 0;

    for (const [start, stop, duration] of events) {
      const ds = new Date(start);
      const de = new Date(stop);
      const minute = ds.getMinutes();
      const minuteEnd = de.getMinutes();
      for (let m = minute; m < minuteEnd; m++) {
        minuteMap[m] ||= 0;
        minuteMap[m]++;

        if (minuteMap[m] > maxAmount) {
          maxAmount = minuteMap[m];
          maxMinute = m;
        }
      }
    }

    return maxMinute;
  }

  sleepiestGuardAtMinute(): number[] {
    let maxMinute = 0;
    let maxAmount = 0;
    let maxGuard = 0;

    for (const [guard, events] of this.guardSleepEvents.entries()) {
      const minuteMap: number[] = [];

      for (const [start, stop, duration] of events) {
        const ds = new Date(start);
        const de = new Date(stop);
        const minute = ds.getMinutes();
        const minuteEnd = de.getMinutes();
        for (let m = minute; m < minuteEnd; m++) {
          minuteMap[m] ||= 0;
          minuteMap[m]++;

          if (minuteMap[m] > maxAmount) {
            maxAmount = minuteMap[m];
            maxMinute = m;
            maxGuard = guard;
          }
        }
      }
    }

    return [maxGuard, maxMinute, maxAmount];
  }
}
