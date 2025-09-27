import 'package:flutter/material.dart';
import 'package:medinote/models/session.dart';
import 'package:medinote/services/api_service.dart';

class SessionProvider with ChangeNotifier {
  final Map<String, List<Session>> _patientSessions = {};
  final Set<String> _expandedSessions = {};
  bool _isLoading = false;
  String? _error;

  List<Session> getSessions(String patientId) =>
      _patientSessions[patientId] ?? [];
  bool isExpanded(String sessionId) => _expandedSessions.contains(sessionId);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSessions(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final sessions = await ApiServiceHandler.instance.getPatientSessions(
        patientId: patientId,
      );
      _patientSessions[patientId] = sessions;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _patientSessions[patientId] = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSessionExpansion(String sessionId) {
    if (_expandedSessions.contains(sessionId)) {
      _expandedSessions.remove(sessionId);
    } else {
      _expandedSessions.add(sessionId);
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
