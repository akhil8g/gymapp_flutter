import 'dart:convert'; // Needed for JSON encoding/decoding
import 'package:objectbox/objectbox.dart';

@Entity()
class WorkoutSplit {
  int id = 0;

  @Unique()
  String splitName;

  // Store the workouts as a JSON string internally
  String _workoutsJson;

  WorkoutSplit({this.id = 0, required this.splitName, required List<String> workouts})
      : _workoutsJson = jsonEncode(workouts);

  // Getter to retrieve the list of workouts
  List<String> get workouts => List<String>.from(jsonDecode(_workoutsJson));

  // Setter to update the workouts list
  set workouts(List<String> value) {
    _workoutsJson = jsonEncode(value);
  }
}

