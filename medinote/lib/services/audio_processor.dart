import 'dart:typed_data';

class AudioProcessor {
  static const int sampleRate = 44100;
  static const int bitsPerSample = 16;
  static const int numChannels = 1;

  static Uint8List pcmToWav(Uint8List pcmData) {
    final byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;
    final blockAlign = numChannels * bitsPerSample ~/ 8;
    final dataSize = pcmData.length;

    final header = ByteData(44);

    // RIFF header
    header.setUint8(0, 0x52);
    header.setUint8(1, 0x49); // 'RIFF'
    header.setUint8(2, 0x46);
    header.setUint8(3, 0x46);

    // File size
    header.setUint32(4, 36 + dataSize, Endian.little);

    // WAVE header
    header.setUint8(8, 0x57);
    header.setUint8(9, 0x41); // 'WAVE'
    header.setUint8(10, 0x56);
    header.setUint8(11, 0x45);

    // fmt subchunk
    header.setUint8(12, 0x66);
    header.setUint8(13, 0x6D); // 'fmt '
    header.setUint8(14, 0x74);
    header.setUint8(15, 0x20);

    header.setUint32(16, 16, Endian.little); // Subchunk1Size
    header.setUint16(20, 1, Endian.little); // AudioFormat (PCM)
    header.setUint16(22, numChannels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);

    // data subchunk
    header.setUint8(36, 0x64);
    header.setUint8(37, 0x61); // 'data'
    header.setUint8(38, 0x74);
    header.setUint8(39, 0x61);
    header.setUint32(40, dataSize, Endian.little);

    return Uint8List.fromList([...header.buffer.asUint8List(), ...pcmData]);
  }

  static List<Uint8List> createChunks(Uint8List pcmData, int chunkSizeMs) {
    final bytesPerMs = (sampleRate * bitsPerSample ~/ 8) ~/ 1000;
    final chunkSizeBytes = chunkSizeMs * bytesPerMs;

    final chunks = <Uint8List>[];

    for (int i = 0; i < pcmData.length; i += chunkSizeBytes) {
      final end = (i + chunkSizeBytes) < pcmData.length
          ? i + chunkSizeBytes
          : pcmData.length;
      final chunkPcm = pcmData.sublist(i, end);
      final wavChunk = pcmToWav(chunkPcm);
      chunks.add(wavChunk);
    }

    return chunks;
  }
}
