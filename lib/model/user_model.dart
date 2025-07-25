class Utilisateur {
  final String id;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String sexe;
  final String email;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'sexe': sexe,
      'email': email,
    };
  }
}