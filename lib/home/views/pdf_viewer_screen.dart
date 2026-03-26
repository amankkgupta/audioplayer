import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  final String title;
  final String pdfUrl;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  Uri _resolvePdfUri(String rawUrl) {
    final uri = Uri.parse(rawUrl);

    if (uri.host.contains('drive.google.com')) {
      final segments = uri.pathSegments;
      final fileIndex = segments.indexOf('d');
      if (fileIndex != -1 && fileIndex + 1 < segments.length) {
        final fileId = segments[fileIndex + 1];
        return Uri.parse(
          'https://drive.google.com/uc?export=download&id=$fileId',
        );
      }
    }

    return uri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SfPdfViewer.network(
        _resolvePdfUri(widget.pdfUrl).toString(),
      ),
    );
  }
}
