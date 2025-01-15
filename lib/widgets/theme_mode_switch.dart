import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/theme_provider.dart';

class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.all(0),
        child: IconButton(
          onPressed: () => value.darkTheme = !value.darkTheme,
          icon: Icon(
            value.darkTheme
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
          ),
        ),
      ),
    );
  }
}
