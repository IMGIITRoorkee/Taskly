import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/enums/repeat_interval.dart';

class RepeatSelectCard extends StatefulWidget {
  const RepeatSelectCard({super.key});

  @override
  State<RepeatSelectCard> createState() => _RepeatSelectCardState();
}

class _RepeatSelectCardState extends State<RepeatSelectCard> {
  final repeatIntervals = [
    RepeatInterval.daily,
    RepeatInterval.weekly,
    RepeatInterval.monthly
  ];

  RepeatInterval? selected;
  final TextEditingController controller = TextEditingController();

  void setSelectedValue(RepeatInterval? value) {
    setState(() => selected = value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select predefined interval",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Choice<RepeatInterval>.inline(
              itemCount: repeatIntervals.length,
              clearable: true,
              multiple: false,
              value: ChoiceSingle.value(selected),
              onChanged: ChoiceSingle.onChanged(setSelectedValue),
              itemBuilder: (state, index) => ChoiceChip(
                label: Text(repeatIntervals[index].getString()),
                selected: state.selected(repeatIntervals[index]),
                onSelected: state.onSelected(repeatIntervals[index]),
              ),
              listBuilder: ChoiceList.createScrollable(
                spacing: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const Row(
              children: [
                Expanded(child: Divider()),
                Text("OR"),
                Expanded(child: Divider()),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Custom days for repeat interval",
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (selected != null) {
                  Navigator.pop(context, selected!.days);
                } else if (controller.text.isNotEmpty &&
                    int.tryParse(controller.text) != null) {
                  Navigator.pop(context, int.tryParse(controller.text));
                } else {
                  Fluttertoast.showToast(msg: "Select a repeat interval!");
                }
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
