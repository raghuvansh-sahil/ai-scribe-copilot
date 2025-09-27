import 'dart:convert';

List<Session> sessionFromJson(String str) {
  final jsonData = json.decode(str);
  final jsonSessions = jsonData["sessions"] as List;
  return jsonSessions.map((json) => Session.fromJson(json)).toList();
}

class Session {
  String id;
  DateTime date;
  String sessionTitle;
  String sessionSummary;
  DateTime startTime;

  Session({
    required this.id,
    required this.date,
    required this.sessionTitle,
    required this.sessionSummary,
    required this.startTime,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json["id"],
    date: DateTime.parse(json["date"]),
    sessionTitle: json["session_title"],
    sessionSummary: json["session_summary"],
    startTime: DateTime.parse(json["start_time"]),
  );
}
