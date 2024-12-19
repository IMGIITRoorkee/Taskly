import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskly/models/task.dart';

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  var hasDeadline = false;
  DateTime? deadline;
  
  @override
  void initState() {
    super.initState();
    editing = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title);
    _descController = TextEditingController(text: widget.task?.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editing ? const Text("Edit Task") : const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title cannot be empty!";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descController,
                decoration:
                    const InputDecoration(labelText: 'Task Description'),
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
                      deadline: hasDeadline ? deadline: null,
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
    );
  }
}
