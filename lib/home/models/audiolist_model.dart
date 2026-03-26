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
    final pdfUrl = json['pdf_url'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return AudioModel(
      title: (json['title'] ?? '').toString(),
      urls: const <String>[],
      pdfUrls: List<String>.from(pdfUrl['urls'] ?? const <String>[]),
    );
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
