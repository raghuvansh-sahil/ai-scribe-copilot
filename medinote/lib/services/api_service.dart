import 'dart:convert';
import 'dart:typed_data';

import 'package:medinote/models/chunk_upload_notification.dart';
import 'package:medinote/models/patient.dart';
import 'package:http/http.dart' as http;
import 'package:medinote/models/presigned_url.dart';
import 'package:medinote/models/recording_session.dart';
import 'package:medinote/models/session.dart';

class ApiService {
  final String baseUrl;
  final String authToken;

  ApiService({required this.baseUrl, required this.authToken});

  Future<List<Patient>> getPatients({required String userId}) async {
    final uri = Uri.parse(
      '$baseUrl/v1/patients',
    ).replace(queryParameters: {'userId': userId});

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final jsonPatients = (jsonData["patients"] as List?) ?? [];
      return jsonPatients.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients: ${response.statusCode}');
    }
  }

  Future<Patient> addPatient(Patient patient) async {
    final uri = Uri.parse('$baseUrl/v1/add-patient-ext');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(patient.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return Patient.fromJson(jsonData["patient"]);
    } else {
      throw Exception(
        'Failed to create patient: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<List<Session>> getPatientSessions({required String patientId}) async {
    final uri = Uri.parse('$baseUrl/v1/fetch-session-by-patient/$patientId');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final sessionsJson = (jsonData["sessions"] as List?) ?? [];
      return sessionsJson.map((json) => Session.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load sessions: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<RecordingSessionResponse> uploadSession(
    RecordingSessionRequest session,
  ) async {
    final uri = Uri.parse('$baseUrl/v1/upload-session');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(session.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return RecordingSessionResponse.fromJson(jsonData["session"]);
    } else {
      throw Exception(
        'Failed to create recording session: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<PresignedUrlResponse> getPresignedUrl(
    PresignedUrlRequest request,
  ) async {
    final uri = Uri.parse('$baseUrl/v1/get-presigned-url');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return PresignedUrlResponse.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to get presigned URL: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<void> uploadAudioChunkToGCS({
    required String presignedUrl,
    required Uint8List audioData,
  }) async {
    final response = await http.put(
      Uri.parse(presignedUrl),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'audio/wav',
      },
      body: audioData,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to upload audio chunk: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Future<void> notifyChunkUploaded(ChunkUploadNotification notification) async {
    final uri = Uri.parse('$baseUrl/v1/notify-chunk-uploaded');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(notification.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to notify chunk upload: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}

class ApiServiceHandler {
  static late final ApiService instance;

  static void init({required String baseUrl, required String authToken}) {
    instance = ApiService(baseUrl: baseUrl, authToken: authToken);
  }
}
