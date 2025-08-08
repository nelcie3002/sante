import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sante/model/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); // ✅ Nouveau champ mot de passe
  final _matriculeController = TextEditingController();
  final _autreFonctionController = TextEditingController();

  String? _sexe;
  String? _fonction;
  String _role = 'utilisateur';

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
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  locale: const Locale('fr', 'FR'),
                );
                if (picked != null) {
                  _dateNaissanceController.text =
                      "${picked.day.toString().padLeft(2, '0')}/"
                      "${picked.month.toString().padLeft(2, '0')}/"
                      "${picked.year}";
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
            _buildTextField(_emailController, "Adresse email"),
            const SizedBox(height: 12),
            _buildTextField(_passwordController, "Mot de passe", isPassword: true), // ✅ Champ mot de passe visible
            const SizedBox(height: 12),
            _buildTextField(_matriculeController, "Matricule"),
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
                final email = _emailController.text.trim();
                final motDePasse = _passwordController.text.trim(); // ✅ Utilisation du mot de passe saisi
                final fonctionFinale = _fonction == 'Autre (précisez)' ? _autreFonctionController.text.trim() : _fonction ?? '';
                final matricule = _matriculeController.text.trim();

                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(email: email, password: motDePasse);

                  final utilisateur = Utilisateur(
                    id: userCredential.user!.uid,
                    nom: nom,
                    prenom: prenom,
                    dateNaissance: dateNaissance,
                    sexe: sexe,
                    email: email,
                    fonction: fonctionFinale,
                    role: _role,
                    statut: 'actif',
                    matricule: matricule,
                  );

                  await FirebaseFirestore.instance
                      .collection('utilisateur')
                      .doc(utilisateur.id)
                      .set(utilisateur.toMap());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Utilisateur créé avec succès !')),
                  );
                  Navigator.pop(context);
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
        hintText: hint ?? '',
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
