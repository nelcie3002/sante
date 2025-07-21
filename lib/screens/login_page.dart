import 'package:flutter/material.dart';
import 'package:sante/widgets/custom_button.dart';


class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/logo.png', height: 80),
                const SizedBox(height: 24),
                const Text(
                  'CONNEXION',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Connectez-vous sur Vyn'),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Adresse e-mail',
                    hintText: 'Entrez votre adresse e-mail',
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Entrez votre mot de passe',
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Se connecter',
                  onPressed: () {
                   
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas de compte ? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/inscription');
                      },
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/mdp_oublie');
                  },
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
