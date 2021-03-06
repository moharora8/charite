import 'package:flutter/foundation.dart';
import '../Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter =
      CharityApp.sharedPreferences.getStringList(CharityApp.userCartList) ==
              null
          ? 0
          : CharityApp.sharedPreferences
                  .getStringList(CharityApp.userCartList)
                  .length -
              1;
  int get count => _counter;

  Future<void> displayResult() async {
    //_counter++;
    print(CharityApp.sharedPreferences
        .getStringList(CharityApp.userCartList)
        .length);
    _counter = CharityApp.sharedPreferences
            .getStringList(CharityApp.userCartList)
            .length -
        1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
