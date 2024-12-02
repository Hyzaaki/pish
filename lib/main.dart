import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Importe a tela de login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CleanAir App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: LoginScreen(), // Define o LoginScreen como a tela inicial
    );
  }
}
