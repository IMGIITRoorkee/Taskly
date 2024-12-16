import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/models/tip.dart';
import 'package:taskly/screens/taskform_screen.dart';
import 'package:taskly/service/random_tip_service.dart';
import 'package:taskly/widgets/theme_mode_switch.dart';
import 'package:taskly/widgets/tip_of_day_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Tip? tip;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    (await RandomTipService().getRandomTip()).when(
      (success) {
        tip = success;
        setState(() {});
      },
      (error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_LONG,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taskly',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: const [ThemeModeSwitch()],
      ),
      body: AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8,
            top: 24,
          ),
          child: TipOfDayCard(tip: tip),
        ),
        secondChild: Container(),
        crossFadeState:
            tip != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(seconds: 1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
