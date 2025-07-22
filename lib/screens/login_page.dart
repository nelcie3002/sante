import 'package:flutter/material.dart';
import 'package:sante/widgets/custom_button.dart';
import 'package:sante/controllers/auth_controller.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _ideController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  // Définir la couleur principale
  final Color primaryColor = const Color(0xFF14A09D);
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GREEN\nSANTE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'CONNEXION',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _ideController,
                          decoration: const InputDecoration(
                            labelText: 'IDE',
                            hintText: 'Value',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Mot de passe',
                            hintText: 'Value',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Se connecter',
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                              _error = null;
                            });
                            String email = _ideController.text.trim();
                            String password = _passwordController.text.trim();
                            String? error = await _authController.login(email, password);
                            setState(() {
                              _loading = false;
                              _error = error;
                            });
                            if (error == null) {
                              // Naviguer vers la page d'accueil ou autre
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                          },
                          color: primaryColor, // Passe la couleur ici
                        ),
                        if (_loading) const CircularProgressIndicator(),
                        if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n’avez pas de compte ? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/inscription');
                      },
                      child: const Text(
                        "Inscrivez-vous",
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
                    "Mot de passe oublié ? Cliquez ici",
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
