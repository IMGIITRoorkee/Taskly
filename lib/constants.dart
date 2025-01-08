//String constants for Kudos history
String completedBeforeDeadline(int daysDiff) =>
    "completed $daysDiff before deadline";
String completedOnTime = "completed on time";
String completedAfterDeadline(int daysDiff) =>
    "completed $daysDiff after deadline";
String completeTaskWithNoDeadline(String task) => "completed $task";
scoreReducedForTask(String task) => "Score reduced for $task";

String stayFocused(int min) => "Stay focused for $min minutes";
String relax(int min) => "Relax for $min minutes";

//Meditation Completion
String ExtraMeditation(int selectedMinutes, int extraSeconds) =>
    "Great job! You meditated for $selectedMinutes minutes and $extraSeconds extra seconds";
String MeditationComplete(int minutesMeditated, int secondsMeditated) =>
    "Session ended. You meditated for $minutesMeditated minutes and $secondsMeditated seconds";
String AskDependencyCompletion = "Complete the dependency first!";
