import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/service/speech_service.dart';
import 'package:taskly/constants.dart';
import 'package:taskly/utils/date_utils.dart';
import 'package:taskly/widgets/repeat_select_card.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final List<Task> availableTasks;

  const TaskFormScreen({super.key, this.task, required this.availableTasks});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _key = GlobalKey<FormState>();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool editing;
  var hasDeadline = false;
  DateTime? deadline;
  Task? selectedDependency;
  Color selectedColor = Colors.blue;
  int? repeatInterval;
  late List<Task> _availableTasks;


  bool isTitleListening = false;


  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    editing = widget.task != null;
    _titleController = TextEditingController(text: widget.task?.title);
    _descController = TextEditingController(text: widget.task?.description);
    selectedDependency = widget.task?.dependency;
    _availableTasks = List<Task>.from(widget.availableTasks);
    if (widget.task != null) {
      _availableTasks.removeWhere((task) => task.id == widget.task!.id);
    }
    hasDeadline = widget.task?.hasDeadline ?? false;
    selectedColor = widget.task?.color ?? Colors.blue;
    _titleController.addListener(_onTitleChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
        repeatInterval =
        widget.task?.recurringDays == 0 ? null : widget.task?.recurringDays;

    if (hasDeadline) deadline = widget.task?.deadline;
  }

    @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

 void _onTitleChanged() {
  final input = _titleController.text.toLowerCase();
  final newSuggestions = suggestions
      .where((suggestion) => suggestion.toLowerCase().startsWith(input))
      .toList();

  if (newSuggestions.isEmpty) {
    _removeOverlay();
  } else {
    setState(() {
      _filteredSuggestions = newSuggestions;
    });
    _updateOverlay(); // Update overlay dynamically
  }
}

void _updateOverlay() {
  if (_overlayEntry != null) {
    _overlayEntry!.remove();
  }
  _createOverlay();
  Overlay.of(context).insert(_overlayEntry!); // Reinserts updated overlay
}

void _createOverlay() {
  _overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      width: _layerLink.leaderSize?.width ?? 300,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: const Offset(0, 50),
        child: Material(
          elevation: 4,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 150, // Constrains the height
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(_filteredSuggestions[index]),
                  onTap: () => _selectSuggestion(_filteredSuggestions[index]),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}



  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectSuggestion(String suggestion) {
    setState(() {
      _titleController.text = suggestion;
      _removeOverlay();
    });
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
                CompositedTransformTarget(
                  link: _layerLink,
                  child: TextFormField(
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
      Card(
        margin: const EdgeInsets.all(0),
        child: ListTile(
          title: const Text("Colour"),
          subtitle: const Text("Select a colour for your task"),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onTap: _showColorPicker,
        ),
      ),
      const SizedBox(height: 16),
      Card(
        margin: const EdgeInsets.all(0),
        child: ListTile(
          title: const Text("Deadline"),
          subtitle: const Text("Select a deadline for your task"),
          trailing: deadlineTrailing,
          onTap: () async {
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
      ),
      const SizedBox(height: 16),
      Card(
        margin: const EdgeInsets.all(0),
        child: ListTile(
          title: const Text("Repeat"),
          subtitle: const Text("Select repeat interval for your task"),
          trailing: repeatTrailing,
          onTap: () async {
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
                                // Dropdown for selecting a dependency task
                DropdownButtonFormField<String?>(
                  value: selectedDependency?.title, // Compare by title
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ..._availableTasks.map((task) {
                      return DropdownMenuItem<String?>(
                        value: task.title, // Use title as the value
                        child: Text(task.title),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newTaskTitle) {
                    setState(() {
                      selectedDependency = _availableTasks.firstWhere(
                        (task) => task.title == newTaskTitle,
                        orElse: () => null as Task,
                      );
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Dependency'),
                ),
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
