import 'package:taskly/models/task.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  static void shareTask(Task t) {
    Share.share("Checkout my task on Taskly!");
  }
}
