// YouTube tutorial video URLs for assessments and exercises.
//
// **Assessment videos** play before each assessment task.
// **Exercise videos** play during the exercise waiting screen.
//
// Keys must match the category names from the backend:
// "Reach", "Grasp", "Manipulation", "Release".

const Map<String, String> assessmentVideoUrls = {
  'Reach': 'https://www.youtube.com/watch?v=rLHncdGS_LM',
  'Grasp': 'https://www.youtube.com/watch?v=3fJjUZVAReE',
  'Manipulation': 'https://www.youtube.com/watch?v=Mcn7dQChtRU',
  'Release': 'https://www.youtube.com/watch?v=gryKpTOupaI',
};

const Map<String, List<String>> exerciseVideoUrls = {
  'Reach': [
    'https://www.youtube.com/watch?v=X6xknjTL9Pk',
    'https://www.youtube.com/watch?v=dOQYnjgu_lE',
  ],
  'Grasp': [
    'https://www.youtube.com/watch?v=wosfBtRSGv8',
    'https://www.youtube.com/watch?v=DQ0Wm5w7WY0',
    'https://www.youtube.com/watch?v=gMoJyBPYIWw',
  ],
  'Manipulation': [
    'https://www.youtube.com/watch?v=sXkI2tPIOn0',
  ],
  'Release': [
    'https://www.youtube.com/watch?v=4MB7xaQmO-I',
  ],
};

const String _fallbackVideoUrl = 'https://www.youtube.com/watch?v=X6xknjTL9Pk';

String videoUrlFor(String exerciseName) =>
    exerciseVideoUrls[exerciseName]?.first ?? _fallbackVideoUrl;

List<String> allVideoUrlsFor(String exerciseName) =>
    exerciseVideoUrls[exerciseName] ?? [_fallbackVideoUrl];

String assessmentVideoUrlFor(String category) =>
    assessmentVideoUrls[category] ?? _fallbackVideoUrl;
