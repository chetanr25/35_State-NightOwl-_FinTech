import 'package:fintech/core/themes.dart';
import 'package:fintech/firebase_options.dart';
import 'package:fintech/home_screen.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/screens/auth.dart';
import 'package:fintech/screens/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    print(ref.watch(userProvider).additionalData);
    print(ref.watch(userProvider).displayName);
    print(ref.watch(userProvider).email);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        debugShowCheckedModeBanner: false,
        // home: HomePage(),
        // home: LoginScreen(),
        // home: RegistrationScreen(),
        home: ref.watch(userProvider).displayName != null &&
                ref.watch(userProvider).displayName != ''
            ? HomePage()
            : LoginScreen()
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting ||
        //           snapshot.connectionState == ConnectionState.none) {
        //         return const Scaffold(
        //           body: Center(
        //             heightFactor: 10,
        //             child: CircularProgressIndicator(),
        //           ),
        //         );
        //       }
        //       if (snapshot.hasData && snapshot.data != null) {
        //         // return AuthScreen();
        //         return HomePage();
        //       }
        //       return LoginScreen();
        //     },
        //   ),
        );
  }
}
