import 'package:flutter/material.dart';

class Consultation extends StatefulWidget {
  const Consultation({super.key});

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "DOSSIER DE CONSULTATION",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Bloc infos patient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.person, size: 18),
                      SizedBox(width: 6),
                      Text("KOUADIO KOFFI", style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text("Âge: 34 ans"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.male, size: 18),
                      SizedBox(width: 6),
                      Text("SEXE: M"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18),
                      SizedBox(width: 6),
                      Text("Date de consultation: 16/07/2025"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("Numéro CMU: 00000000000000"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Pathologies
            const Text(
              "PATHOLOGIES:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextField(
              decoration: InputDecoration(
                hintText: "Value",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),

            // Traitements prescrits
            const Text(
              "TRAITEMENTS PRESCRITS:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(". Paracétamol 500mg"),
            const Text(". Coartem 4x/jour pendant 3 jours"),
            const SizedBox(height: 12),

            // Profil médical
            const Text(
              "Profil médical:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(". Groupe Sanguin: O+"),
            const Text(". Allergies:  Rhinite allergique"),
            const Text(". Pathologies Chroniques: Diabète de type II"),
            const SizedBox(height: 16),

            // Anciennes consultations
            Row(
              children: const [
                Icon(Icons.history),
                SizedBox(width: 6),
                Text(
                  "ANCIENNES CONSULTATIONS:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Liste des anciennes consultations
            Column(
              children: const [
                _OldConsultationTile(date: "03/05/2025", motif: "Grippe"),
                _OldConsultationTile(date: "03/05/2025", motif: "fièvre jaune"),
                _OldConsultationTile(date: "03/05/2025", motif: "Sida"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OldConsultationTile extends StatelessWidget {
  final String date;
  final String motif;

  const _OldConsultationTile({
    required this.date,
    required this.motif,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.access_time),
        title: Text(date),
        trailing: Text(motif, style: const TextStyle(fontWeight: FontWeight.bold)),
        dense: true,
      ),
    );
  }
}