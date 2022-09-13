import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
      ),
      home: Scaffold(
          appBar: AppBar(title: const Text('Hello')),
          body: Column(
            children: [
              const Center(
                child: Text('Flutter Demo'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Click'),
              ),
            ],
          )),
    );
  }
}
