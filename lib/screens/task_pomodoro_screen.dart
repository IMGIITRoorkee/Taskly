import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:taskly/enums/timer_types.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/widgets/spacing.dart';

import 'package:taskly/constants.dart';

class TaskPomodoroScreen extends StatefulWidget {
  final Task task;
  const TaskPomodoroScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskPomodoroScreen> createState() => _TaskPomodoroScreenState();
}

class _TaskPomodoroScreenState extends State<TaskPomodoroScreen> {
  static const int numOfTasksForLongBreak = 4;
  // Define breakpoints
  static const double narrowScreenWidth = 600;

  final CountDownController _controller = CountDownController();
  late Duration _duration;

  TimerTypes _currentTimerType = TimerTypes.work;
  int _workIndex = 1;
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    _updateDuration();
  }

  void _updateDuration() {
    _duration = Duration(minutes: _currentTimerType.defaultMinutes);
  }

  void _onCountdownComplete() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setSourceAsset("sounds/chime.wav");
    audioPlayer.resume();

    if (_currentTimerType == TimerTypes.work) {
      if (_workIndex == numOfTasksForLongBreak) {
        _currentTimerType = TimerTypes.breakLarge;
        _workIndex = 1;
      } else {
        _currentTimerType = TimerTypes.breakSmall;
        _workIndex++;
      }
    } else {
      _currentTimerType = TimerTypes.work;
    }

    _updateDuration();
    _isStarted = false;
    setState(() {});
  }

  void _onMarkAsComplete() {
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 100,
        spread: 70,
        y: 1,
      ),
      onFinished: (overlayEntry) {
        Navigator.pop(context, true);
      },
    );
  }

  Widget _buildTaskCard() {
    return Card(
      child: ListTile(
        title: Text(
          widget.task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.task.description,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: widget.task.hasDeadline
            ? Text(
                MyDateUtils.getFormattedDate(widget.task.deadline!),
                style: const TextStyle(color: Colors.red),
              )
            : null,
      ),
    );
  }

  Widget _buildTimer(double timerSize) {
    if (_isStarted) {
      return CircularCountDownTimer(
        width: timerSize,
        height: timerSize,
        duration: _duration.inSeconds,
        isReverse: true,
        fillColor: Theme.of(context).focusColor,
        ringColor: Theme.of(context).highlightColor,
        strokeWidth: 16,
        isReverseAnimation: true,
        textStyle: Theme.of(context).textTheme.displayMedium,
        controller: _controller,
        onComplete: _onCountdownComplete,
        autoStart: true,
      );
    }

    return DurationPicker(
      duration: _duration,
      baseUnit: BaseUnit.minute,
      width: timerSize,
      height: timerSize,
      lowerBound: Duration(minutes: _currentTimerType.lowerBound),
      upperBound: Duration(minutes: _currentTimerType.upperBound),
      onChange: (value) => setState(() {
        _duration = value;
      }),
    );
  }

  Widget _buildActionButton() {
    IconData actionIcon = _isStarted
        ? (_controller.isPaused.value ? Icons.play_arrow_rounded : Icons.pause_rounded)
        : Icons.play_arrow_rounded;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48),
      ),
      color: Theme.of(context).primaryColorLight,
      child: IconButton(
        onPressed: () {
          if (!_isStarted) {
            setState(() {
              _isStarted = true;
            });
          }
          if (_controller.isPaused.value) {
            _controller.resume();
          } else {
            _controller.pause();
          }
          setState(() {});
        },
        icon: Icon(actionIcon),
        iconSize: 48,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helperText = _currentTimerType == TimerTypes.work
        ? stayFocused(_duration.inMinutes)
        : relax(_duration.inMinutes);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro Timer"),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onMarkAsComplete,
            child: const Text("Mark as Complete"),
          ),
        )
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrowScreen = constraints.maxWidth < narrowScreenWidth;
          final timerSize = isNarrowScreen
              ? constraints.maxWidth * 0.6
              : constraints.maxHeight * 0.6;

          if (isNarrowScreen) {
            // Portrait or narrow screen layout
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTaskCard(),
                    const Spacing(large: true),
                    _buildTimer(timerSize),
                    const Spacing(),
                    Text(helperText),
                    const Spacing(large: true),
                    _buildActionButton(),
                  ],
                ),
              ),
            );
          } else {
            // Landscape or wide screen layout
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _buildTaskCard(),
                          const Spacing(large: true),
                          Text(helperText),
                          const Spacing(large: true),
                          _buildActionButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: _buildTimer(timerSize),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}