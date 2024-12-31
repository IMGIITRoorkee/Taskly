enum TimerTypes {
  work(25, 15, 60),
  breakSmall(5, 2, 5),
  breakLarge(15, 10, 30);

  final int defaultMin;
  final int lowerBound;
  final int upperBound;
  const TimerTypes(this.defaultMin, this.lowerBound, this.upperBound);
}
