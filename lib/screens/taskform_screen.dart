import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/service/permission_service.dart';
import 'package:taskly/service/speech_service.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/widgets/spacing.dart';

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
  double? lat, lng;

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
    lat = widget.task?.lat;
    lng = widget.task?.lng;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editing ? const Text("Edit Task") : const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
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
                        icon: Icon(
                            SpeechService.isListening() & !isTitleListening
                                ? Icons.circle_rounded
                                : Icons.mic_rounded),
                      ),
                      border:
                          const OutlineInputBorder(), // Adds a border for a defined look
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 12), // Adds padding inside the text field
                    ),
                    maxLines:
                        6, // Provides a reasonable height for multi-line input
                    minLines: 4, // Ensures the field has a minimum height
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Description cannot be empty!";
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _showColorPicker,
                      child: const Text('Choose Task Color'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // boolformfield for a bool value (hasDeadline)
                // CheckboxListTile(value: hasDeadline, onChanged: (value)=>{
                //   setState(() {
                //     hasDeadline = value!;
                //   })
                // }, title: const Text('Has Deadline')),

                const SizedBox(height: 5),
                // Date picker field for a DateTime value (deadline)
                if (deadline != null)
                  Text(
                      "Selected Deadline - ${MyDateUtils.getFormattedDate(deadline!)}"),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        hasDeadline = true;
                        deadline = selectedDate;
                      });
                    }
                  },
                  child: const Text('Select Deadline'),
                ),
                const Spacing(),
                ElevatedButton(
                  onPressed: lat != null && lng != null
                      ? null
                      : () async {
                          bool permission =
                              await PermissionService.askForLocation();
                          if (!permission) return;

                          Position position =
                              await Geolocator.getCurrentPosition();
                          setState(() {
                            Fluttertoast.showToast(
                                msg:
                                    "Task will be auto-completed when you are again at this location");
                            lat = position.latitude;
                            lng = position.longitude;
                          });
                        },
                  child: const Text("Autocomplete task at current location"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Task task = Task(
                        title: _titleController.text,
                        description: _descController.text,
                        hasDeadline: hasDeadline,
                        deadline: hasDeadline ? deadline : null,
                        color: selectedColor,
                        lat: lat,
                        lng: lng,
                      );
                      Fluttertoast.showToast(
                          msg: editing
                              ? "Task Successfully Edited!"
                              : "Task Successfully Created!");
                      Navigator.pop(context, task);
                    }
                  },
                  child: const Text('Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
