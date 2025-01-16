import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:taskly/constants.dart';
import 'dart:async';

import 'package:taskly/screens/Meditation_history_box.dart';
import 'package:taskly/storage/meditation_history_storage.dart';

class MeditationScreen extends StatefulWidget {
  final Function kudosForMeditation;

  const MeditationScreen({super.key, required this.kudosForMeditation});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  int selectedMinutes = 5;
  int remainingSeconds = 0;
  int extraSeconds = 0;
  bool isRunning = false;
  bool playaudio = true;
  Timer? timer;
  final audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    audioPlayer.setSource(AssetSource('sounds/meditation.mp3'));
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    timer?.cancel();
    audioPlayer.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      isRunning = true;
      remainingSeconds = selectedMinutes * 60;
      extraSeconds = 0;
    });
    if (playaudio) {
      audioPlayer.resume();
      isAudioPlaying = true;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          extraSeconds++;
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      int timeDiff;
      int totalMeditationTime;
      String message;

      if (remainingSeconds == 0) {
        // Session went over time
        timeDiff = extraSeconds;
        totalMeditationTime = selectedMinutes * 60 + extraSeconds;
        message = extraMeditation(selectedMinutes, extraSeconds);
        if (extraSeconds ~/ 300 > 0) {
          widget.kudosForMeditation(extraSeconds ~/ 300,
              meditationCompleteKudosExtra(extraSeconds ~/ 60));
        }
      } else {
        // Session ended early
        timeDiff = -remainingSeconds;
        totalMeditationTime = (selectedMinutes * 60) - remainingSeconds;
        int minutesMeditated = totalMeditationTime ~/ 60;
        int secondsMeditated = totalMeditationTime % 60;
        message = meditationComplete(minutesMeditated, secondsMeditated);
        if (timeDiff ~/ 300 > 0) {
          widget.kudosForMeditation(
              timeDiff ~/ 300, meditationCompleteKudosLess(timeDiff ~/ 60));
        }
      }
      if (totalMeditationTime >= 300) {
        widget.kudosForMeditation(
            1, meditationCompleteKudos(totalMeditationTime ~/ 60));
      }

      MeditationHistoryStorage.addToHistory(selectedMinutes, timeDiff);

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'Keep up the great work! 🧘‍♂️',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.deepPurple.shade800,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      );

      isRunning = false;
      timer?.cancel();
      if (isAudioPlaying) {
        audioPlayer.pause();
        isAudioPlaying = false;
      }
      remainingSeconds = 0;
      extraSeconds = 0;
    });
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E), // Deep Indigo
              Color(0xFF311B92), // Deep Purple
              Color(0xFF4A148C), // Purple
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background animated circles
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _breathingController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CircleBreathingPainter(
                        progress: _breathingController.value,
                      ),
                    );
                  },
                ),
              ),
              // Main content
              Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'Meditation session',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.history_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => MeditationHistory(
                                onClose: () => Navigator.of(context).pop()),
                          );
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isRunning) ...[
                          const Text(
                            'Mindful Moments with Taskly',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$selectedMinutes minutes',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: Colors.white,
                                    overlayColor: Colors.white.withOpacity(0.1),
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: selectedMinutes.toDouble(),
                                    min: 1,
                                    max: 60,
                                    divisions: 59,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMinutes = value.round();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    const Text(
                                      'Play Audio',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Switch(
                                      value: playaudio,
                                      onChanged: (value) {
                                        setState(() {
                                          playaudio = value;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                        if (isRunning) ...[
                          AnimatedBuilder(
                            animation: _breathingController,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3 +
                                        (_breathingController.value * 0.3)),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius:
                                          _breathingController.value * 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      formatTime(remainingSeconds),
                                      style: const TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (remainingSeconds == 0) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        '+${formatTime(extraSeconds)}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 10),
                                    Text(
                                      remainingSeconds > 0
                                          ? 'Breathe...'
                                          : 'Extra Time',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: isRunning ? stopTimer : startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning
                                ? Colors.red.withOpacity(0.8)
                                : Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            isRunning ? 'End Session' : 'Begin',
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated breathing circles
class CircleBreathingPainter extends CustomPainter {
  final double progress;

  CircleBreathingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw multiple circles with different sizes and opacities
    for (int i = 1; i <= 3; i++) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.05 / i)
        ..style = PaintingStyle.fill;

      double radius = (size.width / 3) * progress * i;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CircleBreathingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
