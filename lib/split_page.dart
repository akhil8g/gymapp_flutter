import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:objectbox/objectbox.dart';
import 'SplitData.dart';

class SplitPage extends StatefulWidget {
  final Store store;

  SplitPage({required this.store});

  @override
  _SplitPageState createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  late final Box<WorkoutSplit> _workoutSplitBox;
  late final Box<SelectedSplit> _selectedSplitBox;
  List<WorkoutSplit> _workoutSplits = [];
  WorkoutSplit? _selectedSplit;

  @override
  void initState() {
    super.initState();
    _workoutSplitBox = widget.store.box<WorkoutSplit>();
    _selectedSplitBox = widget.store.box<SelectedSplit>();
    _fetchSplits();
    _fetchSelectedSplit();
  }

  void _fetchSplits() {
    setState(() {
      _workoutSplits = _workoutSplitBox.getAll();
    });
  }

  void _fetchSelectedSplit() {
    var selectedSplitModel = _selectedSplitBox.getAll().isEmpty
        ? null
        : _selectedSplitBox.getAll().first;
    if (selectedSplitModel != null) {
      _selectedSplit = _workoutSplitBox.get(selectedSplitModel.selectedSplitId);
    }
  }

  void _selectSplit(int index) {
    setState(() {
      for (var split in _workoutSplits) {
        split.isSelected = false;
        _workoutSplitBox.put(split);
      }
      var selectedSplit = _workoutSplits[index];
      selectedSplit.isSelected = true;
      selectedSplit.currentWorkoutIndex = 0; // Reset to the first workout
      _workoutSplitBox.put(selectedSplit);

      // Store selected split ID in SelectedSplit model
      var selectedSplitModel = _selectedSplitBox.getAll().isEmpty
          ? SelectedSplit(selectedSplitId: selectedSplit.id)
          : _selectedSplitBox.getAll().first;
      selectedSplitModel.selectedSplitId = selectedSplit.id;
      _selectedSplitBox.put(selectedSplitModel);

      _fetchSelectedSplit(); // Update the selected split
    });
  }

  void _deleteSplit(int index) {
    setState(() {
      _workoutSplitBox.remove(_workoutSplits[index].id);
      _fetchSplits();
      _fetchSelectedSplit(); // Update the selected split
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Split"),
          content: Text("Are you sure you want to delete this split?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteSplit(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultImageUrl = 'https://cdn-icons-png.flaticon.com/512/2376/2376428.png';
    final selectedImageUrl = _selectedSplit?.imageUrl.isNotEmpty == true
        ? _selectedSplit!.imageUrl
        : defaultImageUrl;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Text("Workout Split",style: GoogleFonts.dancingScript(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold,

        ),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Main selected workout card
              if (_selectedSplit != null)
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(selectedImageUrl),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.orange,
                      width: 3,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.2),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          _selectedSplit?.splitName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              // Grid of workout splits
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _workoutSplits.length,
                  itemBuilder: (context, index) {
                    final splitImageUrl = _workoutSplits[index].imageUrl.isNotEmpty
                        ? _workoutSplits[index].imageUrl
                        : defaultImageUrl;

                      return GestureDetector(
                        onTap: () => _selectSplit(index),
                        onLongPress: () => _showDeleteConfirmationDialog(index), // Handle long press
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(splitImageUrl),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.orange,
                                width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _workoutSplits[index].splitName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
