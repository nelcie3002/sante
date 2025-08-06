import 'package:flutter/material.dart';
import 'package:sante/widgets/custom_button.dart';
import 'package:sante/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _ideController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

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
                            labelText: 'Adresse e-mail',
                            hintText: 'ex: nom@domaine.com',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Mot de passe',
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
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                final uid = user.uid;
                                final doc = await FirebaseFirestore.instance
                                    .collection('utilisateur')
                                    .doc(uid)
                                    .get();

                                if (doc.exists) {
                                  final data = doc.data();
                                  final role = data?['role'] ?? 'utilisateur';
                                  final statut = data?['statut'] ?? 'actif';

                                  if (statut == 'bloqué') {
                                    setState(() {
                                      _error = "Votre compte est bloqué. Veuillez contacter l’administrateur.";
                                    });
                                    await FirebaseAuth.instance.signOut();
                                    return;
                                  }

                                  if (role == 'admin') {
                                    Navigator.pushReplacementNamed(context, '/admin_home');
                                  } else {
                                    Navigator.pushReplacementNamed(context, '/home');
                                  }
                                } else {
                                  setState(() {
                                    _error = "Utilisateur non trouvé dans la base de données.";
                                  });
                                }
                              }
                            }
                          },
                          color: primaryColor,
                        ),
                        const SizedBox(height: 12),
                        if (_loading) const CircularProgressIndicator(),
                        if (_error != null)
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Supprimé : Inscription libre
                // const Text("Vous n’avez pas de compte ?"),
                // const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/reset_password');
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
