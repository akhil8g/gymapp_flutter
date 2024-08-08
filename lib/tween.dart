import 'package:flutter/material.dart';

// Define the TypewriterTween class that extends Tween<String>
class TypewriterTween extends Tween<String> {
  TypewriterTween({String begin = '', String end = ''})
      : super(begin: begin, end: end);

  @override
  String lerp(double t) {
    // Calculate the number of characters to display based on the animation progress
    var cutoff = (end!.length * t).round();
    return end!.substring(0, cutoff);
  }
}
