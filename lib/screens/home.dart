import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userPrenom = '';
  String searchQuery = '';
  bool isLoading = true;
  List<Map<String, dynamic>> consultations = [];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchConsultations();
  }

  Future<void> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('utilisateur').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userPrenom = doc.data()?['prenom'] ?? '';
        });
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchConsultations() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('consultations')
        .orderBy('date', descending: true)
        .limit(20)
        .get();

    setState(() {
      consultations = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nom': data['nom'] ?? '',
          'cmu': data['cmu'] ?? '',
          'pathologie': data['consultation'] ?? '',
          'date': data['date'] ?? '',
        };
      }).toList();
    });
  }

  List<Map<String, dynamic>> get filteredConsultations {
    if (searchQuery.trim().isEmpty) return consultations;
    return consultations.where((c) =>
        c['nom'].toString().toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black87),
          onPressed: () => Navigator.pushNamed(context, '/infos'),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Hello, ", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            Text(isLoading ? "..." : userPrenom, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: "Rechercher une consultation par nom...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
            ),
            const SizedBox(height: 24),

            _HomeActionButton(
              title: "CONSULTATIONS PRECEDENTES",
              onTap: () => Navigator.pushNamed(context, '/consultations'),
            ),
            const SizedBox(height: 12),

            _HomeActionButton(
              title: "CREER UNE NOUVELLE CONSULTATION",
              onTap: () async {
                await Navigator.pushNamed(context, '/nouvelle_consultation');
                fetchConsultations(); // rafraîchit après retour
              },
            ),
            const SizedBox(height: 12),

            _HomeActionButton(
              title: "GENERER UN RAPPORT",
              onTap: () => Navigator.pushNamed(context, '/rapport'),
            ),
            const SizedBox(height: 12),

            const Text("CONSULTATIONS RECENTES", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),

            if (filteredConsultations.isEmpty)
              const Text("Aucune consultation trouvée."),

            ...filteredConsultations.map((c) => InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/dossier_consultation',
                  arguments: c['id'],
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("${c['nom']} (${c['cmu']})", style: const TextStyle(color: Colors.black87)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(c['date'], style: const TextStyle(color: Colors.black87)),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(c['pathologie'], style: const TextStyle(color: Colors.black87)),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _HomeActionButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}