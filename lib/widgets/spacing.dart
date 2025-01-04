import 'package:flutter/material.dart';

class Spacing extends StatelessWidget {
  final bool large;
  const Spacing({
    super.key,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: large ? 32 : 16,
      width: large ? 16 : 8,
    );
  }
}
