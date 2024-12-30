import 'package:taskly/models/task.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  static const String scheme = "taskly";
  static const String host = "taskly.com";

  static void shareTask(Task t) {
    String url = "$scheme:/$host?id=${t.id}";
    Share.share("Checkout my task on Taskly!\nVisit $url");
  }
}
