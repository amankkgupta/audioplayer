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
    return AudioModel(
      title: (json['title'] ?? '').toString(),
      urls: _extractUrls(json, keys: const ['audio_url', 'audio_urls', 'url', 'urls']),
      pdfUrls: const <String>[],
    );
  }

  factory AudioModel.fromBookJson(Map<String, dynamic> json) {
    return AudioModel(
      title: (json['title'] ?? '').toString(),
      urls: const <String>[],
      pdfUrls: _extractUrls(json, keys: const ['pdf_url', 'pdf_urls', 'url', 'urls']),
    );
  }

  static List<String> _extractUrls(Map<String, dynamic> json, {required List<String> keys}) {
    for (final key in keys) {
      final value = json[key];
      final urls = _normalizeUrlValue(value);
      if (urls.isNotEmpty) {
        return urls;
      }
    }
    return const <String>[];
  }

  static List<String> _normalizeUrlValue(dynamic value) {
    if (value == null) {
      return const <String>[];
    }

    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? const <String>[] : <String>[trimmed];
    }

    if (value is List) {
      return value
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }

    if (value is Map<String, dynamic>) {
      final nestedUrls = value['urls'];
      if (nestedUrls is List) {
        return nestedUrls
            .map((item) => item?.toString().trim() ?? '')
            .where((item) => item.isNotEmpty)
            .toList();
      }

      if (nestedUrls is String) {
        final trimmed = nestedUrls.trim();
        if (trimmed.isNotEmpty) {
          return <String>[trimmed];
        }
      }

      final directUrl = value['url'];
      if (directUrl is String) {
        final trimmed = directUrl.trim();
        if (trimmed.isNotEmpty) {
          return <String>[trimmed];
        }
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
