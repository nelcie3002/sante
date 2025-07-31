import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DossierConsultationPage extends StatefulWidget {
  final String consultationId;

  const DossierConsultationPage({super.key, required this.consultationId});

  @override
  State<DossierConsultationPage> createState() => _DossierConsultationPageState();
}

class _DossierConsultationPageState extends State<DossierConsultationPage> {
  Map<String, dynamic>? consultation;
  List<Map<String, dynamic>> anciennesConsultations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchConsultation();
  }

  Future<void> fetchConsultation() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('consultations')
          .doc(widget.consultationId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        consultation = data;
        final cmu = data['cmu'];

        final anciennes = await FirebaseFirestore.instance
            .collection('consultations')
            .where('cmu', isEqualTo: cmu)
            .orderBy('date', descending: true)
            .get();

        anciennesConsultations = anciennes.docs
            .where((d) => d.id != widget.consultationId)
            .map((d) => d.data())
            .toList();
      } else {
        print("Consultation introuvable");
      }
    } catch (e) {
      print("Erreur lors du chargement: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.length < 10) return "-";
    return dateString.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dossier du Patient"),
        backgroundColor: Colors.teal[400],
        centerTitle: true,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : consultation == null
              ? const Center(child: Text("Consultation introuvable"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Informations patient
                        _sectionCard([
                          _sectionTitle("👤 ${consultation!['nom'].toString().toUpperCase()} ${consultation!['prenom']}"),
                          _sectionLine("📆 Date consultation", formatDate(consultation!['date'])),
                          _sectionLine("🧍 Sexe", consultation!['sexe']),
                          _sectionLine("🎂 Âge", "${consultation!['age']} ans"),
                          _sectionLine("🆔 CMU", consultation!['cmu']),
                        ]),
                        const SizedBox(height: 20),

                        // Pathologies
                        _sectionCard([
                          _sectionTitle("🦠 Pathologies"),
                          Text(consultation!['pathologies'] ?? '-', style: const TextStyle(fontSize: 16)),
                        ]),
                        const SizedBox(height: 20),

                        // Traitements
                        _sectionCard([
                          _sectionTitle("💊 Traitements prescrits"),
                          Text(consultation!['traitements'] ?? 'Aucun traitement enregistré', style: const TextStyle(fontSize: 16)),
                        ]),
                        const SizedBox(height: 20),

                        // Profil médical
                        _sectionCard([
                          _sectionTitle("📋 Profil médical"),
                          _sectionLine("Groupe sanguin", consultation!['groupeSanguin'] ?? 'Non précisé'),
                          _sectionLine("Allergies", consultation!['allergies'] ?? 'Non précisé'),
                          _sectionLine("Pathologies chroniques", consultation!['pathologiesChroniques'] ?? 'Non précisé'),
                        ]),
                        const SizedBox(height: 20),

                        // Anciennes consultations
                        if (anciennesConsultations.isNotEmpty)
                          _sectionCard([
                            _sectionTitle("📚 Anciennes consultations"),
                            ...anciennesConsultations.map((a) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: const Icon(Icons.history),
                                  title: Text(a['consultation'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w500)),
                                  subtitle: Text(formatDate(a['date'])),
                                )),
                          ]),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }

  Widget _sectionLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(flex: 4, child: Text(value)),
        ],
      ),
    );
  }
}
