import 'package:shim_app/constants/route_names.dart';
import 'package:shim_app/locator.dart';
import 'package:shim_app/services/authentication_service.dart';
import 'package:shim_app/services/dialog_service.dart';
import 'package:shim_app/services/navigation_service.dart';

import 'base_model.dart';

class AuthViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    required String email,
    required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        var user = _authenticationService.getUser();
        _navigationService.navigateTo(MainViewRoute, arguments: user);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: result,
      );
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }

  Future logout() async {
    setBusy(true);

    var result = await _authenticationService.signOutWithEmail();

    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(LoginViewRoute);
      }
    }
  }
}
