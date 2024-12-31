import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:taskly/enums/timer_types.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/utils/screen_utils.dart';
import 'package:taskly/widgets/spacing.dart';

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

  final CountDownController _controller = CountDownController();
  late Duration _duration;

  TimerTypes _currentTimerType = TimerTypes.work;
  int _workIndex = 1; // the index of the consecutive work timer
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    _updateDuration();
  }

  void _updateDuration() {
    _duration = Duration(minutes: _currentTimerType.defaultMinutes);
  }

  void _onCountdownComplete() {
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

  @override
  Widget build(BuildContext context) {
    final timerSize = ScreenUtils.getPercentOfWidth(context, 0.6);
    final helperText = _currentTimerType == TimerTypes.work
        ? "Stay focused for ${_duration.inMinutes} minutes"
        : "Relax for ${_duration.inMinutes} minutes";
    IconData actionIcon;
    if (_isStarted) {
      actionIcon = _controller.isPaused.value
          ? Icons.play_arrow_rounded
          : Icons.pause_rounded;
    } else {
      actionIcon = Icons.play_arrow_rounded;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomodoro Timer"),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Mark as Complete"),
          ),
        )
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                trailing: Text(
                  MyDateUtils.getFormattedDate(widget.task.deadline),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          const Spacing(large: true),
          if (_isStarted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularCountDownTimer(
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
              ),
            ),
          if (!_isStarted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DurationPicker(
                duration: _duration,
                baseUnit: BaseUnit.minute,
                width: timerSize,
                height: timerSize,
                lowerBound: Duration(minutes: _currentTimerType.lowerBound),
                upperBound: Duration(minutes: _currentTimerType.upperBound),
                onChange: (value) => setState(() {
                  _duration = value;
                }),
              ),
            ),
          const Spacing(),
          Text(helperText),
          const Spacing(large: true),
          Card(
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
          ),
        ],
      ),
    );
  }
}
