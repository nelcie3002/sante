import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations précédentes'),
        backgroundColor: Colors.teal,
      ),
      body: uid == null
          ? const Center(child: Text("Utilisateur non connecté."))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('utilisateur')
                  .doc(uid)
                  .collection('consultations')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucune consultation trouvée.'));
                }

                final consultations = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: consultations.length,
                  itemBuilder: (context, index) {
                    final data = consultations[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text("${data['nom']} ${data['prenom']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Âge : ${data['age']}"),
                            Text("Sexe : ${data['sexe']}"),
                            Text("Consultation : ${data['consultation']}"),
                            Text("Date : ${(data['date'] as Timestamp).toDate().toLocal()}"),
                          ],
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
