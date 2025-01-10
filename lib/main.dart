import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/theme_provider.dart';
import 'package:taskly/screens/home_screen.dart';
import 'package:taskly/screens/intro_screen.dart';
import 'package:taskly/screens/splash_screen.dart';
import 'package:taskly/service/local_db_service.dart';
import 'package:taskly/service/speech_service.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //await EmailService.sendMessage();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  bool first = await LocalDbService.getFirstTime();
  await dotenv.load(fileName: ".env");

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
    themeProvider = ThemeProvider();
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
          darkTheme: ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Quicksand',
                ),
          ),
          themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
          // home: widget.isFirstTime ? const IntroScreen() : const HomeScreen(),
          initialRoute: '/',
          routes: {
            '/': (context) =>
                SplashScreen(), // Add Splash Screen as the initial route
            '/main': (context) =>
                widget.isFirstTime ? const IntroScreen() : const HomeScreen(),
          },
        ),
      ),
    );
  }
}
