enum TimerTypes {
  work(25, 1, 60), //TODO change to 15
  breakSmall(5, 2, 5),
  breakLarge(15, 10, 30);

  final int defaultMinutes;
  final int lowerBound;
  final int upperBound;
  const TimerTypes(this.defaultMinutes, this.lowerBound, this.upperBound);
}
