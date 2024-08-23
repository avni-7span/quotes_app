import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (FirebaseAuth.instance.currentUser != null) {
      resolver.next(true);
    } else {
      resolver.redirect(const LoginRoute());
    }
  }
}
