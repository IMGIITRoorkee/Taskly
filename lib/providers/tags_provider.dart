import 'package:flutter/material.dart';
import 'package:taskly/models/tag.dart';

class TagsProvider extends ChangeNotifier {
  List<Tag> allTags = [];

  void updateTags(List<Tag> tags) {
    allTags = tags;
    notifyListeners();
  }
}
