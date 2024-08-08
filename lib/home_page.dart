// home_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'SplitData.dart';
import 'package:objectbox/objectbox.dart';

class HomePage extends StatefulWidget {
  final Store store; // Store instance to access ObjectBox

  HomePage({required this.store});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box<WorkoutSplit> _workoutSplitBox;
  late final Box<SelectedSplit> _selectedSplitBox;
  WorkoutSplit? _selectedSplit;

  @override
  void initState() {
    super.initState();
    _workoutSplitBox = widget.store.box<WorkoutSplit>();
    _selectedSplitBox = widget.store.box<SelectedSplit>();
    _fetchSelectedSplit();
  }

  void _fetchSelectedSplit() {
    final selectedSplitModel = _selectedSplitBox.getAll().isEmpty
        ? null
        : _selectedSplitBox.getAll().first;

    if (selectedSplitModel != null) {
      setState(() {
        _selectedSplit = _workoutSplitBox.get(selectedSplitModel.selectedSplitId);
      });
    }
  }

  void _nextDay() {
    if (_selectedSplit != null) {
      setState(() {
        _selectedSplit!.nextWorkout();
        _workoutSplitBox.put(_selectedSplit!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              _selectedSplit != null
                  ? "Today's ${_selectedSplit!.workouts[_selectedSplit!.currentWorkoutIndex]}!"
                  : "No Split Selected",
              style: GoogleFonts.dancingScript(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Icon(Icons.fitness_center, size: 150, color: Colors.orange),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 150),
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    _nextDay();
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.orange, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 150),
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    // Skip action
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.orange, fontSize: 18),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
