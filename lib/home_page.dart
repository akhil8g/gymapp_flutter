import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_app/tween.dart';
import 'SplitData.dart';
import 'package:objectbox/objectbox.dart';

class HomePage extends StatefulWidget {
  final Store store; // Store instance to access ObjectBox

  HomePage({required this.store});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _showImage = false;
  String _imageUrl = ''; // To store the image URL to be displayed

  void _onButtonPressed(String imageUrl) {
    setState(() {
      _showImage = true;
      _imageUrl = imageUrl;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        _showImage = false;
      });
    });
  }

  late final Box<WorkoutSplit> _workoutSplitBox;
  late final Box<SelectedSplit> _selectedSplitBox;
  WorkoutSplit? _selectedSplit;

  late AnimationController _animationController;
  late Animation<String> _typewriterAnimation;

  static const Duration _animationDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _workoutSplitBox = widget.store.box<WorkoutSplit>();
    _selectedSplitBox = widget.store.box<SelectedSplit>();

    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _typewriterAnimation = TypewriterTween(end: '').animate(_animationController);

    _fetchSelectedSplit();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchSelectedSplit() {
    final selectedSplitModel = _selectedSplitBox.getAll().isEmpty
        ? null
        : _selectedSplitBox.getAll().first;

    if (selectedSplitModel != null) {
      setState(() {
        _selectedSplit = _workoutSplitBox.get(selectedSplitModel.selectedSplitId);
        if (_selectedSplit != null) {
          _updateTypewriterText(
              "Today's ${_selectedSplit!.workouts[_selectedSplit!.currentWorkoutIndex]} Day!");
        } else {
          _updateTypewriterText("No Split Selected");
        }
      });
    }
  }

  void _nextDay() {
    if (_selectedSplit != null) {
      _onButtonPressed('https://cdn-icons-png.flaticon.com/512/2376/2376428.png');
      //https://cdn-icons-png.flaticon.com/512/2376/2376428.png// Show the "Done" image
      setState(() {
        _selectedSplit!.nextWorkout();
        _workoutSplitBox.put(_selectedSplit!);
        _updateTypewriterText(
            "Today's ${_selectedSplit!.workouts[_selectedSplit!.currentWorkoutIndex]} Day!");
      });
    }
  }

  void _skipDay() {
    if (_selectedSplit != null) {
      _onButtonPressed("https://cdn-icons-png.flaticon.com/512/9305/9305700.png");
    //https://cdn-icons-png.flaticon.com/512/9305/9305700.png// Show the "Skip" image
      // Add skip logic here if needed
    }
  }

  void _updateTypewriterText(String newText) {
    setState(() {
      _typewriterAnimation = TypewriterTween(end: newText).animate(_animationController);
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                AnimatedBuilder(
                  animation: _typewriterAnimation,
                  builder: (context, child) {
                    return Text(
                      _typewriterAnimation.value,
                      style: GoogleFonts.dancingScript(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),

                    );
                  },
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
                      onPressed: _nextDay,
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
                      onPressed: _skipDay,
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
          // Animated image
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: _showImage ? 20.0 : -100.0, // Position relative to the bottom
            left: 0,
            right: 0,
            child: Center(
              child: Image.network(
                _imageUrl, // Show the selected image
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
