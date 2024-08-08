import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'SplitData.dart';
import 'package:google_fonts/google_fonts.dart';


class NewPage extends StatefulWidget {
  final Store store;

  NewPage({required this.store});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final TextEditingController _splitNameController = TextEditingController();
  final TextEditingController _workoutController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final List<String> _workouts = [];

  void _addWorkout() {
    if (_workoutController.text.isNotEmpty) {
      setState(() {
        _workouts.add(_workoutController.text);
        _workoutController.clear();
      });
    }
  }

  void _submitSplit() {
    if (_splitNameController.text.isNotEmpty && _workouts.isNotEmpty) {
      final workoutSplit = WorkoutSplit(
        splitName: _splitNameController.text,
        workouts: _workouts,
        imageUrl: _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : 'https://cdn-icons-png.flaticon.com/512/2376/2376428.png', // Default URL if empty
      );

      final box = widget.store.box<WorkoutSplit>();
      box.put(workoutSplit);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout Split Added!')),
      );

      // Clear the fields after submission
      _splitNameController.clear();
      _imageUrlController.clear();
      setState(() {
        _workouts.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a split name and at least one workout.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Set background color
      appBar: AppBar(
        title: Text('Add New Split',style: GoogleFonts.dancingScript(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black, // Optional: Set AppBar background color
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _splitNameController,
              decoration: InputDecoration(
                labelText: 'Split Name',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                fillColor: Colors.grey[800], // Set background color
                filled: true,
              ),
              style: TextStyle(color: Colors.white), // Set text color
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(
                labelText: 'Add Workout',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                fillColor: Colors.grey[800], // Set background color
                filled: true,
              ),
              style: TextStyle(color: Colors.white), // Set text color
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _addWorkout,
              child: Text('Add Workout to List'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, // Set button text color
                backgroundColor: Colors.orange, // Set button color
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _workouts[index],
                      style: TextStyle(color: Colors.white), // Set text color
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Set icon color
                      onPressed: () {
                        setState(() {
                          _workouts.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL (optional)',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                fillColor: Colors.grey[800], // Set background color
                filled: true,
              ),
              style: TextStyle(color: Colors.white), // Set text color
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitSplit,
              child: Text('Submit Split'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, // Set button text color
                backgroundColor: Colors.orange, // Set button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
