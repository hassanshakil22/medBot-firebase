import 'package:firebase_authProject/features/app/splash_screen.dart';
import 'package:firebase_authProject/features/user_auth/views/home_view.dart';
import 'package:firebase_authProject/features/user_auth/views/signUp_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SplashView(
        child: SignUpView(),
      ),
    );
  }
}
