import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/audiolist_model.dart';

class HomeService {
  HomeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<AudioModel>> fetchBooks() async {
    try {
      final response = await _client
          .from("geetahindi")
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
