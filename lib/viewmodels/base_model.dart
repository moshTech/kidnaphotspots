import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;
  bool _resetBusy = false;
  bool get busy => _busy;
  bool get anonymousBusy => _resetBusy;

  void loginSetBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void resetSetBusy(bool value) {
    _resetBusy = value;
    notifyListeners();
  }
}
