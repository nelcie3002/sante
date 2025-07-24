import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _dateNaissanceController = TextEditingController();
  final TextEditingController _ideController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _sexe;
  final List<String> sexes = ['Masculin', 'Féminin', 'Autre'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_nomController, "Nom"),
            const SizedBox(height: 12),
            _buildTextField(_prenomController, "Prénoms"),
            const SizedBox(height: 12),
            _buildTextField(_dateNaissanceController, "Date de naissance", hint: "jj/mm/aaaa"),
            const SizedBox(height: 12),
            _buildDropdownField(),
            const SizedBox(height: 12),
            _buildTextField(_ideController, "IDE (Adresse email)"),
            const SizedBox(height: 12),
            _buildTextField(_passwordController, "Mot de passe", isPassword: true),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () {
                final nom = _nomController.text.trim();
                final prenom = _prenomController.text.trim();
                final dateNaissance = _dateNaissanceController.text.trim();
                final sexe = _sexe;
                final ide = _ideController.text.trim();
                final motDePasse = _passwordController.text.trim();

                // TODO: Envoyer ces données vers ton backend Firebase ou base de données

                print("Nom: $nom");
                print("Prénoms: $prenom");
                print("Date de naissance: $dateNaissance");
                print("Sexe: $sexe");
                print("Email: $ide");
                print("Mot de passe: $motDePasse");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Compte créé avec succès !')),
                );

                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text("S'inscrire", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false, String? hint}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? 'Value',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _sexe,
      decoration: const InputDecoration(
        labelText: 'Sexe',
        border: OutlineInputBorder(),
      ),
      items: sexes.map((sexe) {
        return DropdownMenuItem(
          value: sexe,
          child: Text(sexe),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _sexe = value;
        });
      },
    );
  }
}
