// SplitData.dart
import 'package:objectbox/objectbox.dart';

@Entity()
class WorkoutSplit {
  @Id()
  int id;
  String splitName;
  bool isSelected;
  int currentWorkoutIndex;
  List<String> workouts; // List of workout names
  String imageUrl; // Image URL for the workout split

  WorkoutSplit({
    this.id = 0,
    required this.splitName,
    this.isSelected = false,
    this.currentWorkoutIndex = 0,
    this.workouts = const [],
    this.imageUrl = '', // Default to an empty string
  });

  void nextWorkout() {
    if (workouts.isNotEmpty) {
      currentWorkoutIndex = (currentWorkoutIndex + 1) % workouts.length;
    }
  }

  void skipWorkout() {
    // Skip logic here
  }
}


@Entity()
class SelectedSplit {
  @Id()
  int id;
  int selectedSplitId;

  SelectedSplit({this.id = 0, this.selectedSplitId = 0});
}