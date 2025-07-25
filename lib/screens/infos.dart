import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Infos extends StatefulWidget {
  const Infos({super.key});

  @override
  State<Infos> createState() => _InfosState();
}

class _InfosState extends State<Infos> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('utilisateur').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _editInfos() async {
    final contactController = TextEditingController(text: userData?['contact'] ?? '');
    final lieuController = TextEditingController(text: userData?['lieuNaissance'] ?? '');
    final adresseController = TextEditingController(text: userData?['adresse'] ?? '');
    final emailController = TextEditingController(text: userData?['email'] ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier les informations"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputField("Contact", contactController),
              _buildInputField("Lieu de naissance", lieuController),
              _buildInputField("Adresse", adresseController),
              _buildInputField("Email", emailController),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              await FirebaseFirestore.instance.collection('utilisateur').doc(uid).update({
                'contact': contactController.text.trim(),
                'lieuNaissance': lieuController.text.trim(),
                'adresse': adresseController.text.trim(),
                'email': emailController.text.trim(),
              });
              if (emailController.text.trim().isNotEmpty) {
                await FirebaseAuth.instance.currentUser!.updateEmail(emailController.text.trim());
              }
              Navigator.pop(context, true);
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );

    if (result == true) {
      fetchUserData(); // Refresh data
    }
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("Aucune donnée utilisateur trouvée."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: const AssetImage('assets/avatar.jpeg'),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Données d'identification
                      _SectionCard(
                        title: "Données d'identification",
                        onEdit: _editInfos,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prénoms: ${userData!['prenom'] ?? ''}"),
                            Text("Nom: ${userData!['nom'] ?? ''}"),
                            Text("Adresse Electronique: ${userData!['email'] ?? ''}"),
                            Text("Contact: ${userData!['contact'] ?? '-'}"),
                            Text("IDE: ${FirebaseAuth.instance.currentUser?.uid ?? ''}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Données personnelles
                      _SectionCard(
                        title: "Données personnelles",
                        onEdit: _editInfos,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date de naissance: ${userData!['dateNaissance'] ?? ''}"),
                            Text("Sexe: ${userData!['sexe'] ?? ''}"),
                            Text("Lieu de Naissance: ${userData!['lieuNaissance'] ?? '-'}"),
                            Text("Adresse: ${userData!['adresse'] ?? '-'}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Configuration
                      _SectionCard(
                        title: "Configuration",
                        onEdit: () {},
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.lock_outline),
                              title: const Text("Changer le mot de passe"),
                              onTap: () {
                                Navigator.of(context).pushNamed('/change_password');
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text("Fermer la session"),
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Déconnexion"),
                                    content: const Text("Voulez-vous vraiment fermer la session ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Annuler"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text("Oui"),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacementNamed('/');
                                }
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onEdit;

  const _SectionCard({
    required this.title,
    required this.child,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit,
            ),
          ],
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ],
    );
  }
}
