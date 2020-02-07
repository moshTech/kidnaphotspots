import 'package:flutter/foundation.dart';
import 'package:kidnaphotspots/services/authentication_service.dart';
import 'package:kidnaphotspots/services/dialog_service.dart';

import '../locator.dart';
import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  // final NavigationService _navigationService = locator<NavigationService>();

  Future register(
      {@required String email,
      @required String matricNo,
      @required String password}) async {
    loginSetBusy(true);
    var result = await _authenticationService.registerWithEmail(
        email: email, password: password);

    loginSetBusy(false);
    if (result is bool) {
      if (result) {
        await _dialogService.showDialog(
          title: 'Sign Up Success',
          description:
              'Your account has been created successfully. You can now login.',
        );
        // _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }
}
