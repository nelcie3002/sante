import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RapportPage extends StatefulWidget {
  const RapportPage({super.key});

  @override
  State<RapportPage> createState() => _RapportPageState();
}

class _RapportPageState extends State<RapportPage> {
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> consultations = [];
  bool isLoading = false;

  Future<void> _selectDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });

      fetchFilteredConsultations();
    }
  }

  Future<void> fetchFilteredConsultations() async {
    if (startDate == null || endDate == null) return;

    setState(() => isLoading = true);

    final snapshot = await FirebaseFirestore.instance
        .collection('consultations')
        .where('date', isGreaterThanOrEqualTo: startDate!.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate!.add(const Duration(days: 1)).toIso8601String())
        .orderBy('date')
        .get();

    consultations = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() => isLoading = false);
  }

  String getAgeRange(String ageStr) {
    final age = int.tryParse(ageStr);
    if (age == null) return 'Inconnu';
    if (age <= 4) return '0-4';
    if (age <= 9) return '5-9';
    if (age <= 14) return '10-14';
    if (age <= 19) return '15-19';
    if (age <= 24) return '20-24';
    if (age <= 49) return '25-49';
    return '50+';
  }

  Future<void> generatePdfReport() async {
    final pdf = pw.Document();
    final dateFormatter = DateFormat('dd/MM/yyyy');

    final Map<String, Map<String, int>> stats = {};
    final ageRanges = ['0-4', '5-9', '10-14', '15-19', '20-24', '25-49', '50+'];

    for (var c in consultations) {
      final ageRange = getAgeRange(c['age'] ?? '');
      final consultation = c['consultation'] ?? 'Inconnu';

      stats.putIfAbsent(consultation, () => {
        for (var r in ageRanges) r: 0,
        'Total': 0,
      });

      stats[consultation]![ageRange] = stats[consultation]![ageRange]! + 1;
      stats[consultation]!['Total'] = stats[consultation]!['Total']! + 1;
    }

    final headers = ['Consultation', ...ageRanges, 'Total'];

    final data = stats.entries.map((entry) {
      final row = [entry.key];
      for (var r in ageRanges) {
        row.add(entry.value[r].toString());
      }
      row.add(entry.value['Total'].toString());
      return row;
    }).toList();

    final totalRow = ['TOTAL'];
    for (var r in ageRanges) {
      final sum = stats.values.fold(0, (prev, e) => prev + e[r]!);
      totalRow.add(sum.toString());
    }
    final totalAll = stats.values.fold(0, (prev, e) => prev + e['Total']!);
    totalRow.add(totalAll.toString());
    data.add(totalRow);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('Rapport de consultations', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text(
            'Période : ${startDate != null ? dateFormatter.format(startDate!) : ''} - ${endDate != null ? dateFormatter.format(endDate!) : ''}',
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            cellAlignment: pw.Alignment.center,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal100),
            border: pw.TableBorder.all(color: PdfColors.grey),
            cellHeight: 25,
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Générer un rapport"),
        backgroundColor: Colors.teal[100],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.date_range),
              label: const Text("Choisir une période"),
              onPressed: () => _selectDateRange(context),
            ),
            if (startDate != null && endDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Période sélectionnée : ${dateFormatter.format(startDate!)} - ${dateFormatter.format(endDate!)}",
                ),
              ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (consultations.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: consultations.length,
                        itemBuilder: (context, index) {
                          final c = consultations[index];
                          return Card(
                            child: ListTile(
                              title: Text("${c['nom']} ${c['prenom']}"),
                              subtitle: Text("CMU : ${c['cmu']} — ${c['consultation']}"),
                              trailing: Text(dateFormatter.format(DateTime.parse(c['date']))),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Télécharger le PDF"),
                      onPressed: generatePdfReport,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    )
                  ],
                ),
              )
            else if (startDate != null && endDate != null)
              const Text("Aucune consultation trouvée pour cette période."),
          ],
        ),
      ),
    );
  }
}
