import Advent from '../src/main';
import { expect } from 'chai';

describe('Advent', () => {
  const input: string = `
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
`.trim();

  let ad;

  beforeEach(() => {
    ad = new Advent(input);
  });

  describe('#new', () => {
    it('inits a list of sorted events', () => {
      expect(ad.guardEvents).to.have.lengthOf(17);
      const [dt, action] = ad.guardEvents.entries().next()['value'];
      expect(dt).to.eql(new Date('1518-11-01 00:00'));
      expect(action).to.eql('Guard #10 begins shift');
    });

    it('inits a list of events with start, stop, and durations keyed by gaurd', () => {
      expect(ad.guardSleepEvents).to.have.lengthOf(2);
      const [guard, events] = ad.guardSleepEvents.entries().next()['value'];
      expect(guard).to.eql(10);
      const [start, stop, duration] = events[0];
      expect(start).to.eql(+new Date('1518-11-01 00:05'));
      expect(stop).to.eql(+new Date('1518-11-01 00:25'));
      expect(duration).to.eql(20);
    });
  });

  describe('#sleepiestGuard', () => {
    it('returns the guard that sleeps the most', () => {
      expect(ad.sleepiestGuard()).to.eql(10);
    });
  });

  describe('#sleepiestMinute', () => {
    it('returns the sleepiest minute for that guard', () => {
      expect(ad.sleepiestMinute(10)).to.eql(24);
    });
  });

  describe('#sleepiestGuardAtMinute', () => {
    it('returns the guard and minute where the guard is asleep', () => {
      expect(ad.sleepiestGuardAtMinute()).to.eql([99, 45, 3]);
    });
  });
});
