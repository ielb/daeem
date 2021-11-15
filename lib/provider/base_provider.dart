// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";


  bool get isLoading => _isLoading;


  setBusy(bool load) {
    _isLoading = load;
    notifyListeners();
  }
  setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

}
