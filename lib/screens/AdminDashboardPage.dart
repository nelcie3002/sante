import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> completerChampsUtilisateurs() async {
  final utilisateurs = FirebaseFirestore.instance.collection('utilisateur');

  final snapshot = await utilisateurs.get();
  for (var doc in snapshot.docs) {
    final data = doc.data();

    final Map<String, dynamic> updates = {};

    if (!data.containsKey('role')) {
      updates['role'] = 'utilisateur';
    }

    if (!data.containsKey('statut')) {
      updates['statut'] = 'actif';
    }

    if (updates.isNotEmpty) {
      await utilisateurs.doc(doc.id).update(updates);
    }
  }

  print("Champs manquants complétés !");
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment fermer la session ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Oui"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord administrateur'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fonctionnalités administratives',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    color: Colors.amber[100],
                    child: ListTile(
                      leading: const Icon(Icons.build),
                      title: const Text("Corriger les utilisateurs"),
                      subtitle: const Text("Ajoute les champs manquants : rôle, statut"),
                      onTap: () async {
                        await completerChampsUtilisateurs();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Mise à jour des utilisateurs terminée.")),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person_add),
                      title: const Text("Ajouter un utilisateur"),
                      subtitle: const Text("Créer un compte utilisateur (médecin, infirmier...)"),
                      onTap: () => Navigator.pushNamed(context, '/register'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text("Voir tous les utilisateurs"),
                      subtitle: const Text("Lister et modifier les rôles, informations..."),
                      onTap: () => Navigator.pushNamed(context, '/liste_utilisateurs'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.analytics),
                      title: const Text("Statistiques de consultations"),
                      subtitle: const Text("Générer un rapport PDF ou voir les tendances"),
                      onTap: () => Navigator.pushNamed(context, '/rapport'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Paramètres administrateur"),
                      subtitle: const Text("Ajouter des fonctionnalités futures..."),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Fonctionnalité à venir.")),
                        );
                      },
                    ),
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
