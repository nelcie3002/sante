import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sante/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  locale: const Locale('fr', 'FR'),
                );
                if (pickedDate != null) {
                  _dateNaissanceController.text =
                      "${pickedDate.day.toString().padLeft(2, '0')}/"
                      "${pickedDate.month.toString().padLeft(2, '0')}/"
                      "${pickedDate.year}";
                }
              },
              child: AbsorbPointer(
                child: _buildTextField(
                  _dateNaissanceController,
                  "Date de naissance",
                  hint: "jj/mm/aaaa",
                ),
              ),
            ),
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
              onPressed: () async {
                final nom = _nomController.text.trim();
                final prenom = _prenomController.text.trim();
                final dateNaissance = _dateNaissanceController.text.trim();
                final sexe = _sexe ?? '';
                final ide = _ideController.text.trim();
                final motDePasse = _passwordController.text.trim();

                try {
                  // 1. Création du compte dans Firebase Auth
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: ide,
                    password: motDePasse,
                  );

                  // 2. Création du modèle utilisateur
                  final utilisateur = Utilisateur(
                    id: userCredential.user!.uid, // Utilise l'UID Firebase Auth
                    nom: nom,
                    prenom: prenom,
                    dateNaissance: dateNaissance,
                    sexe: sexe,
                    email: ide,
                  );

                  // 3. Ajout à Firestore
                  await FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(utilisateur.id)
                      .set(utilisateur.toMap());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compte créé avec succès !')),
                  );

                  Navigator.pushReplacementNamed(context, '/');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : ${e.toString()}')),
                  );
                }
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
