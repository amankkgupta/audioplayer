import 'package:flutter/foundation.dart';
import '../models/audiolist_model.dart';
import '../services/home_service.dart';

class HomeVm extends ChangeNotifier {
  HomeVm({HomeService? service}) : _service = service ?? HomeService();

  final HomeService _service;

  bool _isLoading = false;
  String? _errorMessage;
  List<AudioModel> _bookList = <AudioModel>[];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<AudioModel> get bookList => _bookList;


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
