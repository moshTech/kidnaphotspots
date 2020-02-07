import 'package:flutter/foundation.dart';
import 'package:kidnaphotspots/constants/route_names.dart';
import 'package:kidnaphotspots/services/authentication_service.dart';
import 'package:kidnaphotspots/services/dialog_service.dart';
import 'package:kidnaphotspots/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login(
      {@required String email,
      @required String matricNo,
      @required String password}) async {
    loginSetBusy(true);

    var result = await _authenticationService.loginWithEmail(
        email: email, password: password);

    loginSetBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'Couldn\'t login at this moment. Please try again later',
        );
      }
    } else if (result.toString().contains('An internal error has occurred.')) {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description:
            "No internet connection. Check your internet connection and try again.",
      );
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }
}
