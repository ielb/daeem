import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;



  bool get isLoading => _isLoading;


  setBusy(bool load) {
    _isLoading = load;
    notifyListeners();
  }

}
