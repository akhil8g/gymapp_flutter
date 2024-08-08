import 'package:flutter/material.dart';
import 'SplitData.dart';
import 'package:objectbox/objectbox.dart';

class SplitPage extends StatefulWidget {
  final Store store; // Store passed from main.dart

  SplitPage({required this.store});

  @override
  _SplitPageState createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  late final Box<WorkoutSplit> _workoutSplitBox;
  List<WorkoutSplit> _workoutSplits = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _workoutSplitBox = widget.store.box<WorkoutSplit>();
    _fetchSplits();
  }

  void _fetchSplits() {
    setState(() {
      _workoutSplits = _workoutSplitBox.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Set background color to grey 900
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Text("Workout Splits"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Main selected workout card
              if (_workoutSplits.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage('https://cdn-icons-png.flaticon.com/512/2376/2376428.png'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.orange, // Add orange outline
                      width: 3, // Outline width
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
                          _workoutSplits[_selectedIndex].splitName,
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
                    if (index == _selectedIndex) {
                      return SizedBox.shrink(); // Skip the selected item in the grid
                    }
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage('https://cdn-icons-png.flaticon.com/512/2376/2376428.png'),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.orange, // Add orange outline
                              width: 3, // Outline width
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
