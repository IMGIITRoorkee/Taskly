enum TimerTypes {
  work(25, 15, 60),
  breakSmall(5, 2, 5),
  breakLarge(15, 10, 30);

  final int defaultMinutes;
  final int lowerBound;
  final int upperBound;
  const TimerTypes(this.defaultMinutes, this.lowerBound, this.upperBound);
}
