import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sante/firebase_options.dart';
import 'package:sante/screens/home.dart';
import 'package:sante/screens/login_page.dart';
import 'package:sante/screens/form_page.dart'; 
import 'package:sante/screens/infos.dart';
import 'package:sante/screens/register_page.dart';
import 'package:sante/screens/reset_password_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const ConnexionPage(),
        '/home': (context) => const Home(),
        '/nouvelle_consultation': (context) => const FormulairePage(), 
        '/infos': (context) => const Infos(),
        '/register': (context) => const RegisterPage(),
        '/reset_password': (context) => const ResetPasswordPage(),

      },
    );
  }
}
