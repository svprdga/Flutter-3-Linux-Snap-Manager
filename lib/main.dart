import 'package:flutter/material.dart';
import 'package:flutter_3_linux/main_screen.dart';
import 'package:yaru/yaru.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const YaruTheme(
        child: MainScreen(),
      ),
    );
  }
}
