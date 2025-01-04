//String constants for Kudos history
String completedBeforeDeadline(int days_diff) => "completed $days_diff before deadline";
String completedOnTime = "completed on time";
String completedAfterDeadline(int days_diff) => "completed $days_diff after deadline";
String completeTaskWithNoDeadline(String task) => "completed $task";
scoreReducedForTask(String task) => "Score reduced for $task";

//Meditation Completion
String ExtraMeditation(int selectedMinutes, int extraSeconds) => "Great job! You meditated for $selectedMinutes minutes and $extraSeconds extra seconds";
String MeditationComplete(int minutesMeditated, int secondsMeditated) => "Session ended. You meditated for $minutesMeditated minutes and $secondsMeditated seconds";
