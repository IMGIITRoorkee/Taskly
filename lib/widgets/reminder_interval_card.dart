import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:taskly/enums/reminder_interval.dart';

class ReminderIntervalCard extends StatefulWidget {
  final int? reminderInterval;
  const ReminderIntervalCard({
    super.key,
    this.reminderInterval,
  });

  @override
  State<ReminderIntervalCard> createState() => _ReminderIntervalCardState();
}

class _ReminderIntervalCardState extends State<ReminderIntervalCard> {
  final reminderIntervals = [
    ReminderInterval.oneHour,
    ReminderInterval.fiveHour,
    ReminderInterval.oneDay,
    ReminderInterval.twoDay,
    ReminderInterval.oneWeek,
  ];

  ReminderInterval? selected;

  @override
  void initState() {
    super.initState();
    if (widget.reminderInterval != null) {
      for (var element in reminderIntervals) {
        if (element.interval == widget.reminderInterval) {
          selected = element;
          setState(() {});
        }
      }
    }
  }

  void setSelectedValue(ReminderInterval? value) {
    Navigator.pop(context, value?.interval);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Choice<ReminderInterval>.inline(
        itemCount: reminderIntervals.length,
        clearable: true,
        multiple: false,
        value: ChoiceSingle.value(selected),
        onChanged: ChoiceSingle.onChanged(setSelectedValue),
        itemBuilder: (state, index) => ChoiceChip(
          label: Text(reminderIntervals[index].title),
          selected: state.selected(reminderIntervals[index]),
          onSelected: state.onSelected(reminderIntervals[index]),
        ),
        listBuilder: ChoiceList.createWrapped(
          spacing: 10,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
