import 'package:flutter/material.dart';
import 'package:gym_app/add_new.dart';
import 'home_page.dart';
import 'split_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:objectbox/objectbox.dart';
import 'SplitData.dart';
import 'objectbox.g.dart';

late final Store store;

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ObjectBox
  store = await openStore();

  // Now run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePage(),
      SplitPage(store: store), // Pass the store to SplitPage
      NewPage(store: store),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    store.close(); // Close the store when the app is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // Show elevation
        onItemSelected: _onItemTapped,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.orange,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Split'),
            activeColor: Colors.orange,
            inactiveColor: Colors.white,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text('New Split'),
            activeColor: Colors.orange,
            inactiveColor: Colors.white,
          ),
        ],
        backgroundColor: Colors.grey[800], // Lighter grey background color
      ),
    );
  }
}
