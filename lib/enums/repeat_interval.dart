enum RepeatInterval {
  daily(1),
  weekly(7),
  monthly(30);

  const RepeatInterval(this.days);
  final int days;
}

extension ToString on RepeatInterval {
  String getString() {
    return "${name.toString()[0].toUpperCase()}${name.toString().substring(1)}";
  }
}
