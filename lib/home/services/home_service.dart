import 'package:bhagavad_gita_english/home/models/audiolist_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeService {
  HomeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<AudioModel>> fetchAudios() async {
    try {
      final response = await _client
          .from("audiolist")
          .select("title,audio_url")
          .order('id', ascending: true);
      List<AudioModel> list = (response as List)
          .map((e) => AudioModel.fromAudioJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      throw Exception("Failed to load audios");
    }
  }

  Future<List<AudioModel>> fetchBooks() async {
    try {
      final response = await _client
          .from("audiolist")
          .select("title,pdf_url")
          .order('id', ascending: true);
      List<AudioModel> list = (response as List)
          .map((e) => AudioModel.fromBookJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } catch (e) {
      throw Exception("Failed to load books");
    }
  }
}
