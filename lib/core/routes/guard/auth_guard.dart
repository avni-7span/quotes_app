import 'package:auto_route/auto_route.dart';
import 'package:quotes_app/core/authentication-repository/authentication_repository.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (AuthenticationRepository.instance.currentUser != null &&
        AuthenticationRepository.instance.currentUser?.emailVerified == true) {
      resolver.next(true);
    } else {
      resolver.redirect(const LoginRoute());
    }
  }
}
