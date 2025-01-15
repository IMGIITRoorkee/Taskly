import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/service/local_db_service.dart';
import 'package:taskly/widgets/spacing.dart';

class EmailReminderCard extends StatefulWidget {
  const EmailReminderCard({super.key});

  @override
  State<EmailReminderCard> createState() => _EmailReminderCardState();
}

class _EmailReminderCardState extends State<EmailReminderCard> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    String? email = await LocalDbService.getUserEmail();
    controller = TextEditingController(text: email ?? "");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            const Spacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await LocalDbService.removeUserEmail();
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Enter your email");
                      return;
                    }
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(controller.text);
                    if (!emailValid) {
                      Fluttertoast.showToast(msg: "Enter a valid email");
                      return;
                    }
                    await LocalDbService.setUserEmail(controller.text);
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
