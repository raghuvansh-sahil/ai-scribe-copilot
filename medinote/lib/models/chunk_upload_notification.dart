class ChunkUploadNotification {
  String sessionId;
  String gcsPath;
  int chunkNumber;
  bool isLast;
  int totalChunksClient;
  String publicUrl;
  String mimeType;
  String selectedTemplate;
  String selectedTemplateId;
  String model;

  ChunkUploadNotification({
    required this.sessionId,
    required this.gcsPath,
    required this.chunkNumber,
    required this.isLast,
    required this.totalChunksClient,
    required this.publicUrl,
    required this.mimeType,
    required this.selectedTemplate,
    required this.selectedTemplateId,
    required this.model,
  });

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'gcsPath': gcsPath,
    'chunkNumber': chunkNumber,
    'isLast': isLast,
    'totalChunksClient': totalChunksClient,
    'publicUrl': publicUrl,
    'mimeType': mimeType,
    'selectedTemplate': selectedTemplate,
    'selectedTemplateId': selectedTemplateId,
    'model': model,
  };
}
