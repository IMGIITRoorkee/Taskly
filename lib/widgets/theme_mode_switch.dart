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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: IconButton(
        onPressed: () => themeProvider.darkTheme = !themeProvider.darkTheme,
        icon: Icon(
          themeProvider.darkTheme
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
        ),
      ),
    );
  }
}
