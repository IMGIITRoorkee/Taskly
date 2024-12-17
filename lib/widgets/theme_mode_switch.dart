import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/theme_provider.dart';

class ThemeModeSwitch extends StatefulWidget {
  const ThemeModeSwitch({super.key});

  @override
  State<ThemeModeSwitch> createState() => _ThemeModeSwitchState();
}

class _ThemeModeSwitchState extends State<ThemeModeSwitch> {
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "Dark Mode",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              width: 5,
            ),
            Switch(
              value: themeProvider.darkTheme,
              onChanged: (v) {
                themeProvider.darkTheme = v;
              },
            ),
          ],
        ),
      ),
    );
  }
}
