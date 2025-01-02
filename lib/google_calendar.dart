import 'package:url_launcher/url_launcher.dart';

void openGoogleCalendar({
  required String title,
  required String description,
  required DateTime deadline,
}) async {
  // Set the start date as today's date
  DateTime startDate = DateTime.now();

  // Set the end date as the deadline
  DateTime endDate = deadline;

  // Format dates in UTC without separators (Google Calendar format)
  String start = startDate.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0] + 'Z';
  String end = endDate.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.')[0] + 'Z';

  // Construct the Google Calendar URL
  final String url =
      'https://calendar.google.com/calendar/render?action=TEMPLATE&text=$title&details=$description&dates=$start/$end';

  print("Start: $start");
  print("End: $end");

  // Launch the URL
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open Google Calendar.';
  }
}
