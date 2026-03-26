import 'package:flutter/foundation.dart';
import '../models/audiolist_model.dart';
import '../services/home_service.dart';

class HomeVm extends ChangeNotifier {
  HomeVm({HomeService? service}) : _service = service ?? HomeService();

  final HomeService _service;

  bool _isLoading = false;
  String? _errorMessage;
  List<AudioModel> _audioList = <AudioModel>[];
  List<AudioModel> _bookList = <AudioModel>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AudioModel> get audioList => _audioList;
  List<AudioModel> get bookList => _bookList;

  Future<void> fetchAudios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _audioList = await _service.fetchAudios();
    } catch (_) {
      _errorMessage = "Unable to load audios.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookList = await _service.fetchBooks();
    } catch (_) {
      _errorMessage = "Unable to load books.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
