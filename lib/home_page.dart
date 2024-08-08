import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.grey[900], // Darker background color for the Scaffold
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align items to the top
          children: [
            const SizedBox(height: 100), // Adjust vertical space to move text down
             Text(
              'Today\'s Leg Day !', // Example, will be dynamic later
              style: GoogleFonts.dancingScript(
                fontSize: 50, // Larger font size
                color: Colors.white,
                fontWeight: FontWeight.bold, // Optional: Bold text for emphasis
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
                    minimumSize: const Size(150, 150), // Square button size
                    backgroundColor: Colors.transparent, // Background color
                    side: const BorderSide(color: Colors.orange, width: 2), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded edges
                    ),
                    padding: const EdgeInsets.all(0), // No extra padding needed for square buttons
                  ),
                  onPressed: () {
                    // Logic for Done button
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.orange, fontSize: 18), // Text color and size
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 150), // Square button size
                    backgroundColor: Colors.transparent, // Background color
                    side: const BorderSide(color: Colors.orange, width: 2), // Border color and width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded edges
                    ),
                    padding: const EdgeInsets.all(0), // No extra padding needed for square buttons
                  ),
                  onPressed: () {
                    // Logic for Skip button
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.orange, fontSize: 18), // Text color and size
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
