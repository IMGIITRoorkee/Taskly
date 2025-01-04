import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/enums/repeat_interval.dart';

class RepeatSelectCard extends StatefulWidget {
  final int? repeatInterval;
  const RepeatSelectCard({super.key, this.repeatInterval});

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

  @override
  void initState() {
    super.initState();
    if (widget.repeatInterval != null) {
      for (var element in repeatIntervals) {
        if (element.days == widget.repeatInterval) {
          setSelectedValue(element);
          return;
        }
      }

      controller.text = "${widget.repeatInterval}";
    }
  }

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
                enabled: selected == null,
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Custom days for repeat interval",
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selected != null) {
                      Navigator.pop(context, selected!.days);
                    } else {
                      int? custom = int.tryParse(controller.text);
                      if (controller.text.isEmpty || custom == null) {
                        Fluttertoast.showToast(
                            msg: "Select a repeat interval!");
                      } else {
                        if (custom <= 0) {
                          Fluttertoast.showToast(
                              msg:
                                  "Repeat interval must be greater than 0 days!");
                        } else {
                          Navigator.pop(context, custom);
                        }
                      }
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
