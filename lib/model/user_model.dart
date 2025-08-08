class Utilisateur {
  final String id;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String sexe;
  final String email;
  final String? contact;
  final String? lieuNaissance;
  final String? adresse;
  final String? fonction;
  final String role;
  final String? statut;
  final String matricule; // peut valoir 'actif' ou 'bloqué'


  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    required this.email,
    this.contact,
    this.lieuNaissance,
    this.adresse,
    required this.fonction,
    required this.role,
    this.statut,
    required this.matricule, // add this line to initialize 'statut'
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'sexe': sexe,
      'email': email,
      'contact': contact ?? '',
      'lieuNaissance': lieuNaissance ?? '',
      'adresse': adresse ?? '',
      'statut': statut,

    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map, String id) {
    return Utilisateur(
      id: id,
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      dateNaissance: map['dateNaissance'] ?? '',
      sexe: map['sexe'] ?? '',
      email: map['email'] ?? '',
      contact: map['contact'],
      lieuNaissance: map['lieuNaissance'],
      adresse: map['adresse'],
      fonction: map['fonction'] ?? '',
      role: map['role'] ?? '',
      statut: map['statut'] ?? 'actif',
      matricule: map['matricule'] ?? '', 
    );
  }
}
