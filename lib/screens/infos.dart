import 'package:flutter/material.dart';

class Infos extends StatefulWidget {
  const Infos({super.key});

  @override
  State<Infos> createState() => _InfosState();
}

class _InfosState extends State<Infos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/avatar.jpeg'), // Remplace par ton image
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // Données d'identification
            _SectionCard(
              title: "Données d'identification",
              onEdit: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Prénoms: Vincent"),
                  Text("Nom: Vincent"),
                  Text("Adresse Electronique: vincent@gmail.com"),
                  Text("Contact: 0102030405"),
                  Text("IDE: 20250715"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Données personnelles
            _SectionCard(
              title: "Données personnelles",
              onEdit: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Date de naissance: 10/10/1992"),
                  Text("Sexe: Masculin"),
                  Text("Lieu de Naissance: Côte d'ivoire-COCODY"),
                  Text("Adresse: Riviera Cocody"),
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
                    onTap: () {},
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Fermer la session"),
                    onTap: () {},
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