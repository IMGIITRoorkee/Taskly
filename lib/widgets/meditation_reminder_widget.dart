import 'package:flutter/material.dart';
import 'package:taskly/enums/meditation_reminder_options.dart';
import 'package:taskly/screens/meditation_screen.dart';

class MeditationCheckDialog extends StatelessWidget {
  const MeditationCheckDialog({Key? key}) : super(key: key);

  void _showSimpleCelebration(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SimpleCheckMark(
            onComplete: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.self_improvement,
                size: 48,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            
            // Question text
            const Text(
              'Did you meditate today?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(MeditationReminderOptions.yesAlreadyDone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Yes Already Done 👍',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(MeditationReminderOptions.meditateNow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Meditate Now 🧘‍♂️',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                
                TextButton(
                  onPressed: () => Navigator.of(context).pop(MeditationReminderOptions.later),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'I will do it later',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleCheckMark extends StatefulWidget {
  final VoidCallback onComplete;

  const SimpleCheckMark({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<SimpleCheckMark> createState() => _SimpleCheckMarkState();
}

class _SimpleCheckMarkState extends State<SimpleCheckMark> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0),
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
        size: 80,
      ),
    );
  }
}

void showMeditationCheckDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const MeditationCheckDialog(),
  ).then((value) {
    if (value == MeditationReminderOptions.yesAlreadyDone){
              const MeditationCheckDialog()._showSimpleCelebration(context);
    }
    else if (value == MeditationReminderOptions.meditateNow){
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MeditationScreen()),
        );
    }
    else if (value== MeditationReminderOptions.later){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Don't forget to take a moment for yourself today"),
            duration: Duration(seconds: 2),
          ),
        );
    }
  });
}
