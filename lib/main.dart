import 'package:flutter/material.dart';
import 'package:oupi/homepage.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(primary: Colors.teal),
         textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Hyperion'),
        ),
      ),
      home: const HomePage(),
    );
  }
}
