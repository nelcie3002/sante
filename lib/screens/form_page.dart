import 'package:flutter/material.dart';

class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  State<FormulairePage> createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _autreConsultationController = TextEditingController();

  String? _sexe;
  String? _consultation;

  final List<String> sexes = ['Homme', 'Femme', 'Autre'];
  final List<String> consultations = [
    'NÉGATIF',
    'POSITIF',
    'PALUDISME SIMPLE',
    'TOUX',
    'RHUME',
    'ANGINE',
    'ORL',
    'DIARRHÉE',
    'VARICELLE',
    'DERMATOSE',
    'ANÉMIE',
    'ASTHME',
    'ACCIDENT DE LA VOIE PUBLIQUE',
    'BRULURE',
    'AVC',
    'LOMBALGIE',
    'HTA',
    'TRAUMATISME',
    'MORSURE DE SERPENT/SCORPION',
    'SYNDROME INFECTIEUX',
    'IST',
    'ULCÈRE',
    'REFERE',
    'MEO',
    'AUTRES MALADIES',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildTextField(_nomController, 'Nom'),
                        const SizedBox(height: 12),
                        _buildTextField(_prenomController, 'Prénoms'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _ageController,
                          'Âge',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Sexe',
                          value: _sexe,
                          items: sexes,
                          onChanged: (value) {
                            setState(() {
                              _sexe = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildDropdownField(
                          label: 'Consultation',
                          value: _consultation,
                          items: consultations,
                          onChanged: (value) {
                            setState(() {
                              _consultation = value;
                            });
                          },
                        ),
                        if (_consultation == 'AUTRES MALADIES') ...[
                          const SizedBox(height: 12),
                          TextField(
                            controller: _autreConsultationController,
                            decoration: const InputDecoration(
                              labelText: 'Précisez la consultation',
                              hintText: 'Ex : fièvre typhoïde',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      final nom = _nomController.text;
                      final prenom = _prenomController.text;
                      final age = _ageController.text;
                      final sexe = _sexe;
                      final consultationFinale = _consultation == 'AUTRES MALADIES'
                          ? _autreConsultationController.text
                          : _consultation;

                      // Ici tu peux traiter les données, les envoyer à un backend, ou les afficher :
                      print('Nom : $nom');
                      print('Prénom : $prenom');
                      print('Âge : $age');
                      print('Sexe : $sexe');
                      print('Consultation : $consultationFinale');
                    },
                    child: const Text(
                      'Soumettre',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Value',
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
        hintText: 'Value',
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
