import 'package:fintech/core/themes.dart';
import 'package:fintech/firebase_options.dart';
import 'package:fintech/home_screen.dart';
import 'package:fintech/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      // home: HomePage(),
      home: LoginScreen(),
    );
  }
}
