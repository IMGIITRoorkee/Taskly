import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/theme_provider.dart';
import 'package:taskly/screens/home_screen.dart';
import 'package:taskly/screens/intro_screen.dart';
import 'package:taskly/service/local_db_service.dart';
import 'package:taskly/service/speech_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool first = await LocalDbService.getFirstTime();
  runApp(TasklyApp(
    isFirstTime: first,
  ));
}

class TasklyApp extends StatefulWidget {
  final bool isFirstTime;
  const TasklyApp({
    super.key,
    required this.isFirstTime,
  });

  @override
  State<TasklyApp> createState() => _TasklyAppState();
}

class _TasklyAppState extends State<TasklyApp> {
  late ThemeProvider themeProvider;


  @override
  void initState() {
    super.initState();
    themeProvider =
        ThemeProvider();
    SpeechService.intialize();
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
            fontFamily: 'Quicksand',
          ),
          darkTheme: ThemeData.dark(),
          themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
          home: widget.isFirstTime ? const IntroScreen() : const HomeScreen(),
        ),
      ),
    );
  }
}
