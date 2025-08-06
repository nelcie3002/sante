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
  final TextEditingController _autreFonctionController = TextEditingController();

  String? _sexe;
  String? _fonction;
  String _role = 'utilisateur'; // Par défaut, chaque nouveau compte est "utilisateur"

  final List<String> sexes = ['Masculin', 'Féminin', 'Autre'];
  final List<String> fonctions = ['Médecin', 'Infirmier', 'Technicien de laboratoire', 'Autre (précisez)'];
  final List<String> roles = ['utilisateur', 'admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un compte utilisateur"),
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
            _buildDropdownField(label: 'Sexe', value: _sexe, items: sexes, onChanged: (val) => setState(() => _sexe = val)),
            const SizedBox(height: 12),
            _buildDropdownField(label: 'Fonction', value: _fonction, items: fonctions, onChanged: (val) => setState(() => _fonction = val)),
            if (_fonction == 'Autre (précisez)')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _buildTextField(_autreFonctionController, "Précisez la fonction"),
              ),
            const SizedBox(height: 12),
            _buildDropdownField(label: 'Rôle', value: _role, items: roles, onChanged: (val) => setState(() => _role = val!)),
            const SizedBox(height: 12),
            _buildTextField(_ideController, "Adresse email"),
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
                final fonctionFinale = _fonction == 'Autre (précisez)' ? _autreFonctionController.text.trim() : _fonction ?? '';

                try {
                  // Créer le compte utilisateur via Firebase Auth
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: ide,
                    password: motDePasse,
                  );

                  final utilisateur = Utilisateur(
                    id: userCredential.user!.uid,
                    nom: nom,
                    prenom: prenom,
                    dateNaissance: dateNaissance,
                    sexe: sexe,
                    email: ide,
                    fonction: fonctionFinale,
                    role: _role,
                    statut: 'actif',
                  );

                  await FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(utilisateur.id)
                      .set(utilisateur.toMap());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compte utilisateur créé avec succès !')),
                  );

                  Navigator.pop(context); // Retour au dashboard admin
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : ${e.toString()}')),
                  );
                }
              },
              child: const Text("Créer l'utilisateur", style: TextStyle(color: Colors.white)),
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
        hintText: hint ?? 'Valeur',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
