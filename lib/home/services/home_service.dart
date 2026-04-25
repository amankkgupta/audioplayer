import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/audiolist_model.dart';

class HomeService {
  HomeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<AudioModel>> fetchAudios() async {
    try {
      final response = await _client
          .from('geetahindi')
          .select()
          .order('id', ascending: true);
      return (response as List)
          .map((e) => AudioModel.fromAudioJson(Map<String, dynamic>.from(e as Map)))
          .where((item) => item.urls.isNotEmpty)
          .toList();
    } catch (_) {
      throw Exception('Failed to load audios');
    }
  }

  Future<List<AudioModel>> fetchBooks() async {
    try {
      final response = await _client
          .from('geetahindi')
          .select()
          .order('id', ascending: true);
      return (response as List)
          .map((e) => AudioModel.fromBookJson(Map<String, dynamic>.from(e as Map)))
          .where((item) => item.pdfUrls.isNotEmpty)
          .toList();
    } catch (_) {
      throw Exception('Failed to load books');
    }
  }
}
