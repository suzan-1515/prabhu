import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  set isOnline(bool isOnline1) {
    _isOnline = isOnline1;
    notifyListeners();
  }

  checkConnectivity() {
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    });
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        isOnline = true;
      } else {
        isOnline = false;
      }
    });
  }
}
