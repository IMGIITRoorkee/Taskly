//String constants for Kudos history
String completedBeforeDeadline(int daysDiff) =>
    "completed $daysDiff before deadline";
String completedOnTime = "completed on time";
String completedAfterDeadline(int daysDiff) =>
    "completed $daysDiff after deadline";
String completeTaskWithNoDeadline(String task) => "completed $task";
scoreReducedForTask(String task) => "Score reduced for $task";

//suggestions
final List<String> suggestions = [
  'Grocery shopping',
  'Laundry',
  'Dishwashing',
  'Cooking dinner',
  'Vacuuming',
  'Mopping the floor',
  'Dusting furniture',
  'Watering plants',
  'Feeding pets',
  'Taking out the trash',
  'Paying bills',
  'Filing taxes',
  'Organizing closet',
  'Decluttering workspace',
  'Ironing clothes',
  'Changing bed sheets',
  'Washing car',
  'Making breakfast',
  'Packing lunch',
  'Meal prepping',
  'Walking the dog',
  'Attending yoga class',
  'Gym workout',
  'Meditation session',
  'Evening walk',
  'Reading a book',
  'Studying for exams',
  'Writing a journal',
  'Answering emails',
  'Scheduling appointments',
  'Grocery list planning',
  'Calling a friend',
  'Video conferencing',
  'Taking notes',
  'Watching a webinar',
  'Online shopping',
  'Reviewing expenses',
  'Budget planning',
  'Repairing home appliances',
  'Painting walls',
  'Planting seeds in the garden',
  'Sewing clothes',
  'DIY crafts',
  'Learning a new recipe',
  'Learning a new language',
  'Practicing musical instruments',
  'Listening to a podcast',
  'Watching tutorials',
  'Updating resume',
  'Preparing for an interview',
  'Writing blog posts',
  'Editing photos',
  'Editing videos',
  'Cleaning refrigerator',
  'Organizing pantry',
  'Meal planning',
  'Setting reminders',
  'Replacing light bulbs',
  'Sharpening knives',
  'Fixing plumbing issues',
  'Recycling old items',
  'Donating clothes',
  'Packing for a trip',
  'Unpacking luggage',
  'Making a to-do list',
  'Cleaning windows',
  'Organizing files',
  'Creating backups',
  'Updating software',
  'Cleaning email inbox',
  'Updating contact list',
  'Syncing devices',
  'Sorting laundry',
  'Ironing curtains',
  'Decorating room',
  'Hanging picture frames',
  'Buying birthday gifts',
  'Writing thank-you notes',
  'Managing social media',
  'Printing documents',
  'Binding books',
  'Proofreading documents',
  'Reviewing presentations',
  'Practicing public speaking',
  'Researching topics',
  'Joining webinars',
  'Booking tickets',
  'Checking weather forecast',
  'Updating calendars',
  'Visiting bank',
  'Checking credit score',
  'Renewing insurance policies',
  'Reviewing investment plans',
  'Preparing tax documents',
  'Running errands',
  'Picking up dry cleaning',
  'Buying medicines',
  'Checking prescriptions',
  'Scheduling doctor appointments',
  'Filling water bottles',
  'Replacing batteries',
  'Setting up alarms',
  'Sorting bills and receipts',
  'Placing onl  ine orders',
  'Trying DIY home decor'
];
String stayFocused(int min) => "Stay focused for $min minutes";
String relax(int min) => "Relax for $min minutes";

//Meditation Completion
String extraMeditation(int selectedMinutes, int extraSeconds) =>
    "Great job! You meditated for $selectedMinutes minutes and $extraSeconds extra seconds";
String meditationComplete(int minutesMeditated, int secondsMeditated) =>
    "Session ended. You meditated for $minutesMeditated minutes and $secondsMeditated seconds";
String meditationCompleteKudos (int minute) =>"Complete a $minute minute meditation session";
String meditationCompleteKudosExtra (int minute) =>"$minute minutes of extra meditation.";
String meditationCompleteKudosLess (int minute) =>"$minute minutes of meditation missed.";
String AskDependencyCompletion = "Complete the dependency first!";
String meditationEndedTooSoon() => "Oh no! You stopped meditating too quickly!";
