class PresignedUrlRequest {
  String sessionId;
  int chunkNumber;
  String mimeType;

  PresignedUrlRequest({
    required this.sessionId,
    required this.chunkNumber,
    required this.mimeType,
  });

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'chunkNumber': chunkNumber,
    'mimeType': mimeType,
  };
}

class PresignedUrlResponse {
  String url;
  String gcsPath;
  String publicUrl;

  PresignedUrlResponse({
    required this.url,
    required this.gcsPath,
    required this.publicUrl,
  });

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) =>
      PresignedUrlResponse(
        url: json['url'],
        gcsPath: json['gcsPath'],
        publicUrl: json['publicUrl'],
      );
}
