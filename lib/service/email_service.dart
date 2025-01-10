import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  static String username = dotenv.env['username'] ?? "";
  static String password = dotenv.env['password'] ?? "";

  static Future sendMessage(
      String recipient, String taskName, String desc, String due) async {
    final smtpServer = gmail(username, password);

    String emailTemplate = '''
<!DOCTYPE html>
<html>
<body>
  <p>Hello</p>
  <p>This is a friendly reminder about your upcoming task:</p>
  <p><b>Task Title:</b> $taskName</p>
  <p><b>Description:</b> $desc</p>
  <p><b>Due Date:</b> $due</p>
  <p>Please make sure to complete the task by the due date to stay on track.</p>
  <p>If you have any questions or need further assistance, feel free to reach out.</p>
  <p>Best regards,<br>Taskly Team</p>
</body>
</html>
''';

    final message = Message()
      ..from = Address(username, 'Taskly')
      ..recipients.add(recipient)
      ..subject = 'Reminder for your task: $taskName'
      ..html = emailTemplate;

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      if (kDebugMode) {
        print('Message not sent. ${e.message}');
      }
    }
  }
}
