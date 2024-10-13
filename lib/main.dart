import 'package:flutter/material.dart';
import 'package:meal_tracker/home_screen.dart'; // Імпортуйте екран головної сторінки

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Викликаємо головну сторінку
    );
  }
}
