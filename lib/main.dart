import 'package:flutter/material.dart';
import 'navbar.dart';
import 'features/moves/screens/moves_screen.dart';
import 'features/lines/screens/lines_screen.dart';
import 'features/sandbox/screens/sandbox_screen.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
          appBar: AppBar(
            title: Align(alignment: Alignment.center, child: Text('Demo'))
          ),
          body: Center(
            child: Text('Hello World!'),
          ),
          bottomNavigationBar: FTNavigationBar(),
      ),
    );
  }
}

