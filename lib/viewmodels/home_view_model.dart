import 'package:kidnaphotspots/services/authentication_service.dart';
import 'package:kidnaphotspots/services/dialog_service.dart';
import 'package:kidnaphotspots/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future logout() async {
    await _authenticationService.signOut();

    _navigationService.pop();

    await _dialogService.showDialog(
      title: 'Logout',
      description: 'Logout successful',
    );
  }
}
