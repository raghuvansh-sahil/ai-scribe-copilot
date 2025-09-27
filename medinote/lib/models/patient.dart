import 'dart:convert';

List<Patient> patientsFromJson(String str) {
  final jsonData = json.decode(str);
  final jsonPatients = jsonData["patients"] as List;
  return jsonPatients.map((json) => Patient.fromJson(json)).toList();
}

class Patient {
  String id;
  String name;
  String? userId;
  String? pronouns;

  Patient({required this.id, required this.name, this.userId, this.pronouns});

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json["id"],
    name: json["name"],
    userId: json["user_id"],
    pronouns: json["pronouns"],
  );

  Map<String, dynamic> toJson() => {"name": name, "userId": userId};
}
