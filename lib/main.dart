import 'package:firebase_test/pages/auth_email_screen.dart';
import 'package:firebase_test/pages/auth_screen.dart';
import 'package:firebase_test/pages/profile_anon_screen.dart';
import 'package:firebase_test/pages/profile_email.dart';
import 'package:firebase_test/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
      key: key,
      routes: {
        'profile_page_screen': (context) => const ProfilePage(title: 'Профиль'),
        "auth_page_screen": (context) => AuthPage(title: 'Авторизация'),
        "auth_email_screen": (context) => AuthEmailPage(title: 'Авторизация'),
        "profile_email": (context) => const ProfileEmailPage(title: 'Профиль'),
        "profile_anon": (context) => const ProfileAnonPage(title: "Профиль")
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
          colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 26, 12, 101))),
      home: AuthPage(title: 'Авторизация'),
    );
  }
}
