import 'package:fintech/core/themes.dart';
import 'package:fintech/firebase_options.dart';
import 'package:fintech/home_screen.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: ref.watch(userProvider).profileCompleted
            ? HomePage()
            : const LoginScreen());
  }
}
