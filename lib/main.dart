import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/theme_provider.dart';
import 'package:taskly/screens/home_screen.dart';

void main() {
  runApp(const TasklyApp());
}

class TasklyApp extends StatefulWidget {
  const TasklyApp({super.key});

  @override
  State<TasklyApp> createState() => _TasklyAppState();
}

class _TasklyAppState extends State<TasklyApp> {
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    themeProvider =
        ThemeProvider(dark: Theme.of(context).brightness == Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Taskly',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
