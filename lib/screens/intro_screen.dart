import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:taskly/resources/assets.dart';
import 'package:taskly/screens/home_screen.dart';
import 'package:taskly/service/local_db_service.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Welcome to Taskly",
              image: SvgPicture.asset(Assets.welcome),
              body:
                  "Taskly is your ultimate task management app! Stay organized, set deadlines, and collaborate effortlessly with a clean, intuitive interface designed to boost your productivity.",
            ),
            PageViewModel(
              title: "Add Tasks",
              image: SvgPicture.asset(Assets.addTask),
              body:
                  "Add tasks with detailed descriptions to your list. Attach notes, external links, and more to gain complete insights into each task!",
            ),
            PageViewModel(
              title: "Manage Tasks",
              image: SvgPicture.asset(Assets.manageTask),
              body:
                  "Manage your task list effortlessly on the home screen. Edit tasks, mark them as done, delete multiple tasks at once, search, filter, and explore many more utility features!",
            ),
            PageViewModel(
              title: "Prioritize Tasks",
              image: SvgPicture.asset(Assets.prioritizeTask),
              body:
                  "Prioritize your tasks by adding due dates. Mark them as done, and see completed tasks at the top of the screen for a clearer overview of your day!",
            ),
          ],
          back: const Icon(Icons.arrow_back),
          next: const Icon(Icons.arrow_forward),
          done: const Text("Done"),
          showBackButton: true,
          onDone: () async {
            await LocalDbService.setFirstTime(false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
    );
  }
}
