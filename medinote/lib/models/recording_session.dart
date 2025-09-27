class RecordingSessionRequest {
  String patientId;
  String userId;
  String patientName;
  String status;
  DateTime startTime;
  String templateId;

  RecordingSessionRequest({
    required this.patientId,
    required this.userId,
    required this.patientName,
    required this.status,
    required this.startTime,
    required this.templateId,
  });

  Map<String, dynamic> toJson() => {
    "patientId": patientId,
    "userId": userId,
    "patientName": patientName,
    "status": status,
    "startTime": startTime.toIso8601String(),
    "templateId": templateId,
  };
}

class RecordingSessionResponse {
  String id;

  RecordingSessionResponse({required this.id});

  factory RecordingSessionResponse.fromJson(Map<String, dynamic> json) =>
      RecordingSessionResponse(id: json["id"]);
}
