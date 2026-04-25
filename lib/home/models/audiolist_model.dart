class AudioModel {
  final String title;
  final List<String> urls;
  final List<String> pdfUrls;

  AudioModel({
    required this.title,
    required this.urls,
    required this.pdfUrls,
  });

  factory AudioModel.fromAudioJson(Map<String, dynamic> json) {
    final audioUrl = json['audio_url'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return AudioModel(
      title: (json['title'] ?? '').toString(),
      urls: List<String>.from(audioUrl['urls'] ?? const <String>[]),
      pdfUrls: const <String>[],
    );
  }

  factory AudioModel.fromBookJson(Map<String, dynamic> json) {
    final pdfUrls = _parsePdfUrls(json['pdf_url']);

    return AudioModel(
      title: (json['title'] ?? '').toString(),
      urls: const <String>[],
      pdfUrls: pdfUrls,
    );
  }

  static List<String> _parsePdfUrls(dynamic rawPdfUrl) {
    if (rawPdfUrl is String && rawPdfUrl.trim().isNotEmpty) {
      return <String>[rawPdfUrl];
    }

    if (rawPdfUrl is List) {
      return rawPdfUrl
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (rawPdfUrl is Map<String, dynamic>) {
      final urls = rawPdfUrl['urls'];
      if (urls is List) {
        return urls
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      if (urls is String && urls.trim().isNotEmpty) {
        return <String>[urls];
      }
    }

    return const <String>[];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audio_url': {
        'urls': urls,
      },
      'pdf_url': {
        'urls': pdfUrls,
      },
    };
  }
}
