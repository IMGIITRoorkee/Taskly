import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/service/speech_service.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/widgets/repeat_select_card.dart';
import 'package:taskly/widgets/spacing.dart';
import 'package:taskly/widgets/tags_card.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _key = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool editing;
  var hasDeadline = false;
  DateTime? deadline;
  Color selectedColor = Colors.blue;
  int? repeatInterval;

  bool isTitleListening = false;

  @override
  void initState() {
    super.initState();
    editing = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title);
    _descController = TextEditingController(text: widget.task?.description);
    hasDeadline = widget.task?.hasDeadline ?? false;
    deadline = widget.task?.deadline;
    selectedColor = widget.task?.color ?? Colors.blue;
    repeatInterval =
        widget.task?.recurringDays == 0 ? null : widget.task?.recurringDays;
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Task Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  void _startListening(TextEditingController controller) async {
    if (!SpeechService.isEnabled()) {
      Fluttertoast.showToast(msg: "Something went wrong.");
      return;
    }

    await SpeechService.startListening(
      (result) {
        controller.text = result.recognizedWords;
      },
      (status) {
        if (status == "done") {
          setState(() {});
        }
      },
    );
    setState(() {});
  }

  void _toggleMic(TextEditingController controller) async {
    if (SpeechService.isListening()) {
      await SpeechService.stopListening();
      setState(() {});
    } else {
      _startListening(controller);
    }
  }

  List<Widget> _buildTextfields() {
    return [
      TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          labelText: 'Task Title',
          suffixIcon: IconButton(
            onPressed: () {
              isTitleListening = true;
              _toggleMic(_titleController);
            },
            icon: Icon(SpeechService.isListening() & isTitleListening
                ? Icons.circle_rounded
                : Icons.mic_rounded),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Title cannot be empty!";
          }
          return null;
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: TextFormField(
          controller: _descController,
          decoration: InputDecoration(
            labelText: 'Task Description',
            hintText: 'Enter a detailed description...',
            alignLabelWithHint: true,
            suffixIcon: IconButton(
              onPressed: () {
                isTitleListening = false;
                _toggleMic(_descController);
              },
              icon: Icon(SpeechService.isListening() & !isTitleListening
                  ? Icons.circle_rounded
                  : Icons.mic_rounded),
            ),
            border:
                const OutlineInputBorder(), // Adds a border for a defined look
            contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 12), // Adds padding inside the text field
          ),
          maxLines: 6, // Provides a reasonable height for multi-line input
          minLines: 4, // Ensures the field has a minimum height
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Description cannot be empty!";
            }
            return null;
          },
        ),
      )
    ];
  }

  Widget _buildCard(
      String title, String subtitle, Widget trailing, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  List<Widget> _buildColorDeadlineRepeat() {
    Widget deadlineTrailing;
    if (deadline != null) {
      deadlineTrailing = Text(MyDateUtils.getFormattedDate(deadline!));
    } else {
      deadlineTrailing = const Icon(Icons.date_range_rounded);
    }

    Widget repeatTrailing;
    if (repeatInterval != null) {
      repeatTrailing = Text("$repeatInterval days");
    } else {
      repeatTrailing = const Icon(Icons.repeat_rounded);
    }

    return [
      _buildCard(
        "Colour",
        "Select a colour for your task",
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: selectedColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        _showColorPicker,
      ),
      const Spacing(),
      _buildCard(
        "Deadline",
        "Select a deadline for your task",
        deadlineTrailing,
        () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
          );
          if (selectedDate != null) {
            setState(() {
              hasDeadline = true;
              deadline = selectedDate;
            });
          }
        },
      ),
      const Spacing(),
      _buildCard(
        "Repeat",
        "Select repeat interval for your task",
        repeatTrailing,
        () async {
          int? days = await showDialog(
            context: context,
            builder: (context) {
              return RepeatSelectCard(repeatInterval: repeatInterval);
            },
          );
          if (days != null) {
            if (!hasDeadline) {
              hasDeadline = true;
              deadline = DateTime.now();
            }
          }
          setState(() {
            repeatInterval = days;
          });
        },
      ),
      const Spacing(),
      _buildCard(
        "Tags",
        "Select tags for your task",
        const Icon(Icons.label_outline_rounded),
        () {
          showDialog(
            context: context,
            builder: (context) => const TagsCard(),
          );
        },
      ),
    ];
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_key.currentState!.validate()) {
          Task task = Task(
            title: _titleController.text,
            description: _descController.text,
            hasDeadline: hasDeadline,
            deadline: hasDeadline ? deadline : null,
            recurringDays: repeatInterval,
            color: selectedColor,
          );
          Fluttertoast.showToast(
              msg: editing
                  ? "Task Successfully Edited!"
                  : "Task Successfully Created!");
          Navigator.pop(context, task);
        }
      },
      child: const Text('Save Task'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editing ? const Text("Edit Task") : const Text('Add Task'),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: _buildSaveButton(),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                ..._buildTextfields(),
                const SizedBox(height: 5),
                ..._buildColorDeadlineRepeat(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
