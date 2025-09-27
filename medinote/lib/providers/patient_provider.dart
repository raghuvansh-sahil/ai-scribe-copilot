import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/services/api_service.dart';

class PatientProvider with ChangeNotifier {
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _error;

  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPatients(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _patients = await ApiServiceHandler.instance.getPatients(userId: userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _patients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPatient(Patient patient) async {
    try {
      final newPatient = await ApiServiceHandler.instance.addPatient(patient);
      _patients.add(newPatient);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
