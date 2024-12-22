import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/service/speech_service.dart';

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

  bool isTitleListening = false;

  @override
  void initState() {
    super.initState();
    editing = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title);
    _descController = TextEditingController(text: widget.task?.description);
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
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Task Description',
                    suffixIcon: IconButton(
                      onPressed: () {
                        isTitleListening = false;
                        _toggleMic(_descController);
                      },
                      icon: Icon(SpeechService.isListening() & !isTitleListening
                          ? Icons.circle_rounded
                          : Icons.mic_rounded),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
                // boolformfield for a bool value (hasDeadline)
                // CheckboxListTile(value: hasDeadline, onChanged: (value)=>{
                //   setState(() {
                //     hasDeadline = value!;
                //   })
                // }, title: const Text('Has Deadline')),

                // Date picker field for a DateTime value (deadline)
                ElevatedButton(
                  onPressed: () async {
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
                  child: const Text('Select Deadline'),
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
