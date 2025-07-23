import 'package:flutter/material.dart';
import 'package:sante/firebase_options.dart';
import 'package:sante/screens/home.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:sante/screens/login_page.dart';

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
      title: 'Vyn Connexion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ConnexionPage(), 
       routes: {
        '/home': (context) => const Home(), 
      },
    );
  }
}
