import 'package:flutter/material.dart';
import 'package:taskly/models/tip.dart';

class TipOfDayCard extends StatelessWidget {
  final Tip? tip;
  const TipOfDayCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                "Tip of the Day",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "\"${tip?.content}\"",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 5),
            Text("- ${tip?.author}"),
          ],
        ),
      ),
    );
  }
}
