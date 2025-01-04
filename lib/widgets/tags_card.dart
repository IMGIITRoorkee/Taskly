import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:taskly/models/tag.dart';
import 'package:taskly/providers/tags_provider.dart';
import 'package:taskly/storage/tags_storage.dart';
import 'package:taskly/widgets/spacing.dart';

class TagsCard extends StatefulWidget {
  final List<String> tagIds;
  TagsCard({super.key, List<String>? tags}) : tagIds = tags ?? [];

  @override
  State<TagsCard> createState() => _TagsCardState();
}

class _TagsCardState extends State<TagsCard> {
  late List<Tag> allTags = [];
  late List<Tag> currentShowing = [];
  late List<Tag> selected = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  void _fetchTags() {
    allTags = Provider.of<TagsProvider>(context, listen: false).allTags;
    currentShowing = allTags;

    if (widget.tagIds.isNotEmpty) {
      selected = allTags
          .where((tag) => widget.tagIds.any((element) => element == tag.id))
          .toList();
    }
    setState(() {});
  }

  void setSelected(List<Tag> tags) => setState(() {
        selected = tags;
      });

  void onSubmit() {
    if (selected.isEmpty) {
      Fluttertoast.showToast(msg: "Select tags to submit.");
      return;
    }
    Navigator.pop(context, selected);
  }

  void onCreate() async {
    if (controller.text.isEmpty) {
      Fluttertoast.showToast(msg: "Enter title for the tag!");
      return;
    }
    if (allTags.any((element) => element.title == controller.text)) {
      Fluttertoast.showToast(msg: "A tag with same title exists");
      return;
    }

    Tag tag = Tag(title: controller.text);
    await TagsStorage.saveTags(allTags..add(tag));
    if (mounted) {
      Provider.of<TagsProvider>(context, listen: false).updateTags(allTags);
      Navigator.pop(context, selected..add(tag));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSubmit,
            child: const Text("Submit"),
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              controller: controller,
              hintText: "Start typing tag title...",
              onChanged: (value) {
                setState(() {
                  currentShowing = allTags
                      .where((element) =>
                          element.title.toLowerCase().contains(value))
                      .toList();
                });
              },
            ),
            const Spacing(),
            if (controller.text.isNotEmpty)
              ElevatedButton.icon(
                onPressed: onCreate,
                label: const Text("Create Tag"),
                icon: const Icon(Icons.add),
              ),
            Choice<Tag>.inline(
              itemCount: currentShowing.length,
              clearable: true,
              multiple: true,
              value: selected,
              onChanged: setSelected,
              listBuilder: ChoiceList.createWrapped(
                spacing: 10,
                runSpacing: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
              ),
              itemBuilder: (state, i) {
                return ChoiceChip(
                  selected: state.selected(currentShowing[i]),
                  onSelected: state.onSelected(currentShowing[i]),
                  label: Text(currentShowing[i].title),
                  avatar:
                      CircleAvatar(backgroundColor: currentShowing[i].color),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
