import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListeUtilisateursPage extends StatefulWidget {
  const ListeUtilisateursPage({super.key});

  @override
  State<ListeUtilisateursPage> createState() => _ListeUtilisateursPageState();
}

class _ListeUtilisateursPageState extends State<ListeUtilisateursPage> {
  final CollectionReference utilisateurs =
      FirebaseFirestore.instance.collection('utilisateur');

  Future<void> updateStatut(String uid, String nouveauStatut) async {
    await utilisateurs.doc(uid).update({'statut': nouveauStatut});
  }

  Future<void> updateRole(String uid, String nouveauRole) async {
    await utilisateurs.doc(uid).update({'role': nouveauRole});
  }

  Future<void> supprimerUtilisateur(String uid) async {
    await utilisateurs.doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des utilisateurs"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: utilisateurs.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur de chargement."));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final user = docs[index];
              final data = user.data() as Map<String, dynamic>;

              final nom = data['nom'] ?? '';
              final prenom = data['prenom'] ?? '';
              final email = data['email'] ?? '';
              final role = data.containsKey('role') ? data['role'] : 'utilisateur';
              final statut = data.containsKey('statut') ? data['statut'] : 'actif';

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text("$prenom $nom"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email : $email"),
                      Text("Rôle : $role | Statut : $statut"),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'bloquer') {
                        await updateStatut(user.id, 'bloqué');
                      } else if (value == 'debloquer') {
                        await updateStatut(user.id, 'actif');
                      } else if (value == 'promouvoir') {
                        await updateRole(user.id, 'admin');
                      } else if (value == 'retrograder') {
                        await updateRole(user.id, 'utilisateur');
                      } else if (value == 'supprimer') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Confirmation"),
                            content: Text("Supprimer l'utilisateur $prenom $nom ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Annuler"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Supprimer"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await supprimerUtilisateur(user.id);
                        }
                      }
                    },
                    itemBuilder: (context) {
                      return <PopupMenuEntry<String>>[
                        if (statut != 'bloqué')
                          const PopupMenuItem(
                              value: 'bloquer', child: Text('Bloquer')),
                        if (statut == 'bloqué')
                          const PopupMenuItem(
                              value: 'debloquer', child: Text('Débloquer')),

                        const PopupMenuDivider(),

                        if (role != 'admin')
                          const PopupMenuItem(
                              value: 'promouvoir', child: Text('Promouvoir admin')),
                        if (role == 'admin')
                          const PopupMenuItem(
                              value: 'retrograder',
                              child: Text('Rétrograder utilisateur')),

                        const PopupMenuDivider(),

                        const PopupMenuItem(
                            value: 'supprimer', child: Text('Supprimer')),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
