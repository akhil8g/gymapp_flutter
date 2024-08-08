import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'SplitData.dart';

class NewPage extends StatefulWidget {
  final Store store;

  NewPage({required this.store});

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final TextEditingController _splitNameController = TextEditingController();
  final TextEditingController _workoutController = TextEditingController();
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
      );

      final box = widget.store.box<WorkoutSplit>();
      box.put(workoutSplit);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout Split Added!')),
      );

      // Clear the fields after submission
      _splitNameController.clear();
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

      appBar: AppBar(
        title: Text('Add New Split'),
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [
            TextField(
              controller: _splitNameController,
              decoration: InputDecoration(
                labelText: 'Split Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(
                labelText: 'Add Workout',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _addWorkout,
              child: Text('Add Workout to List'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_workouts[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
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
            ElevatedButton(
              onPressed: _submitSplit,
              child: Text('Submit Split'),
            ),
          ],
        ),
      ),
    );
  }
}
